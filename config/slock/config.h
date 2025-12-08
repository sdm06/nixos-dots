/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
    /* Tokyo Night Colors */
    [INIT] =   "#1a1b26",   /* After initialization (Background) */
    [INPUT] =  "#7aa2f7",   /* during input (Blue) */
    [FAILED] = "#f7768e",   /* wrong password (Red) */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
