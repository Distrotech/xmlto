%{
/*
 * xmlif -- support processing instructions for XML conditionalization
 *
 * By Eric S. Raymond <esr@thyrsus.com>, 3 Nov 1997 (as sgmlpre)
 * Enhanced for XML September 2002, Licensed under GPLv2+ since 03/2009
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Filter XML according to conditionalizing markup.  Argument/value
 * pairs from the command line are matched against the attributes of
 * <?xmlif if> and <?xmlif elif> tags.  Spans between <?xmlif if> or
 * <?xmlif elif> and the next conditional processing instruction are
 * passed through unaltered if there is no attribute mismatch; spans
 * between <?xmlif if not> and <?xmlif elif not> are passed if there
 * is at least one attribute mismatch.  An attribute mismatch happens
 * if an attribute occurs in both the command-line arguments and the
 * tag, but the values do not match.  <?xmlif else> inverts the sense
 * of the current comparison. Value matching is by string equality,
 * except that "|" is interpreted as an alternation character.
 * <?xmlif if>, <?xmlif fi>, <?xmlif else> and <?xmlif elif>, and will
 * all be removed from the output.
 *
 * This lexer requires flex.  Limitations; attributes and values may be
 * only 16384 (YY_BUF_SIZE) characters long.
 */
#include <string.h>
#include <stdlib.h>

#define TRUE	1
#define FALSE	0

static char **selections;	/* selection tokens */
static int nselections;		/* number of selections */
static ifsense;			/* sense of last `if' or unless seen */
static char *attribute;		/* last attribute scanned */

struct stack_t {
    int			matched;	/* matched at current level */
    int			suppressed;    /* suppressed branch? */
    struct stack_t	*up;
};
static struct stack_t head, *end = &head;

static void push_level(void)
/* create activation record for the current level */
{
    struct stack_t *newelt;

#ifdef DEBUG
    fprintf(stderr, "{push_level()}");
#endif /* DEBUG */
    newelt = (struct stack_t *)malloc(sizeof(struct stack_t));
    newelt->up = end;
    end = newelt;

    end->matched = 0;
    end->suppressed = end->up->suppressed;
}

static void pop_level(void)
/* delete activation record for the current level */
{
    struct stack_t *up = end->up;

#ifdef DEBUG
    fprintf(stderr, "{pop_level()}");
#endif /* DEBUG */
    if (end != &head)
    {
	free(end);
	end = up;
    }
}

static void stash_attribute(char *attr)
/* stash an attribute away for comparison */
{
#ifdef DEBUG
    fprintf(stderr, "{stash_attribute(%s)}", attr);
#endif /* DEBUG */
    attribute = strdup(attr);
}

static void end_attribute(void)
/* we've seen all the attributes of a conditional, process them now */
{
    struct stack_t	*up;

    if (attribute)
	free(attribute);
    end->suppressed = (ifsense == !!end->suppressed);
    for (up = end->up; up->up; up = up->up)
	if (up->suppressed)
	{
	    end->suppressed = 1;
	    break;
	}
    if (!end->matched && !end->suppressed)
	end->matched = 1;
#ifdef DEBUG
    fprintf(stderr,"{end_attribute(ifsense=%d)->%d}", ifsense, end->suppressed);
#endif /* DEBUG */
}

static int value_match(char *value, char *against)
/* return TRUE if values match (handles alternation syntax) */
{
    char *vp, *ap;
    int vn, an;

#ifdef DEBUG
    fprintf(stderr, "{value_match(%s, %s)}", value, against);
#endif /* DEBUG */

    for (vp = value; *vp; vp += vn)
    {
	vn = strcspn(vp, "|");
	for (ap = against; *ap; ap += an)
	{
	    an = strcspn(ap, "|");
	    if (an == vn && memcmp(ap, vp, an) == 0)
		return(TRUE);
	    if (ap[an] == '|')
		an++;
	}
	if (vp[vn] == '|')
	    vn++;
    }

    return(FALSE);
}

static int suppress(char *attr, char *value)
/* does a given attribute/value pair enable inclusion? */
{
    int	i;
    int res;

    for (i = 0; i < nselections; i++)
    {
	int eqoffset = strcspn(selections[i], "=");

	if (strncasecmp(selections[i], attr, eqoffset) == 0)
	{
	    /* attribute matches; enable (0) or lock in suppression (-1) */
	    res = value_match(value, selections[i] + eqoffset + 1) ? 0 : -1;
	    goto breakout;
	}
    }

    res = 1;	/* no match -- suppress but don't lock it in */
 breakout:
#ifdef DEBUG
    fprintf(stderr, "{suppress(%s, %s)->%d}", attr, value, res);
#endif /* DEBUG */
    return(res);
}

static void process_value(char *val)
/* process value in context of stashed attribute */
{
    /* if pred has been set to -1 by a mismatch, latch it there */
    if (end->suppressed > -1)
	end->suppressed = suppress(attribute, val);
}

static void process_else()
/* process <?xmlif else> tag */
{
    end->suppressed = end->matched;
#ifdef DEBUG
    fprintf(stderr, "{else -> %d}", end->suppressed);
#endif /* DEBUG */
}


%}

ATTRIBUTE	[a-z][a-z0-9]*
DSTRING		\"[^"]*\"
SSTRING		\'[^']*\'
WS		[ \t\n]*

%x attrib val

%option batch never-interactive fast 8bit

%%
<INITIAL>\<\?xmlif{WS}if{WS}not{WS}	{BEGIN(attrib); ifsense = FALSE; push_level();}
<INITIAL>\<\?xmlif{WS}if{WS}		{BEGIN(attrib); ifsense = TRUE;  push_level();}
<INITIAL>\<\?xmlif{WS}elif{WS}not{WS}	{BEGIN(attrib); ifsense = FALSE;}
<INITIAL>\<\?xmlif{WS}elif{WS}		{BEGIN(attrib); ifsense = TRUE;}
<INITIAL>\<\?xmlif{WS}else\?>		{process_else();}

<INITIAL><\?xmlif{WS}fi\?>		{pop_level();}

<attrib>{ATTRIBUTE}		{stash_attribute(yytext);}
<attrib>=			{BEGIN(val);}
<attrib>\?\>			{BEGIN(INITIAL); end_attribute();}
<val>{DSTRING}|{SSTRING}	{
				    yytext[strlen(yytext)-1]='\0';
				    process_value(yytext+1);
				    BEGIN(attrib);
				}
<val>\?\>				{
				    fprintf(stderr,
					"xmlif: > where value expected\n");
				    exit(1);
				}

<INITIAL>.			{
				    if (!end->suppressed)
					putchar(yytext[0]);
				}

%%
#include <string.h>

#include "config.h"

int yywrap() {exit(0);};

main(int argc, char *argv[])
{
    int i;

    selections = argv + 1;
    nselections = argc - 1;

    for (i = 0; i < nselections; i++)
        if (strchr(selections[i], '=') == 0)
	{
	    if (!strcmp(selections[i], "--help"))
	    {
	        printf ("usage: xmlif attrib=value..\n");
	        exit(0);
	    }

	    if (!strcmp(selections[i], "--version"))
	    {
	        printf ("xmlif - xmlto version %s\n", VERSION);
	        exit(0);
	    }

	    fprintf(stderr, "xmlif: malformed argument %d\n", i);
	    exit(1);
	}

    yylex();
}

/*
 The following sets edit modes for GNU EMACS
 Local Variables:
 mode:c
 case-fold-search:nil
 End:
*/
/* xmlif.l ends here */
