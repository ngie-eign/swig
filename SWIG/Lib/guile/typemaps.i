/* typemaps.i --- guile-specific typemaps -*- c -*-
   Copyright (C) 2000 Matthias Koeppe <mkoeppe@mail.math.uni-magdeburg.de>

   $Header$  */

/* Unlike other SWIG language modules, the Guile module handles all
   types uniformly via typemaps. Here are the definitions.
*/

/* Pointers */

%typemap(in) SWIGTYPE * {
  if (SWIG_Guile_GetPtr($source, (void **) &$target, $descriptor))
    scm_wrong_type_arg(FUNC_NAME, $argnum, $source);
}

%typemap(in) void * {
  if (SWIG_Guile_GetPtr($source, (void **) &$target, NULL))
    scm_wrong_type_arg(FUNC_NAME, $argnum, $source);
}

%typemap(varin) SWIGTYPE * {
  if (SWIG_Guile_GetPtr($source, (void **) &$target, $descriptor))
    scm_wrong_type_arg(FUNC_NAME, $argnum, $source);
}

%typemap(varin) void * {
  if (SWIG_Guile_GetPtr($source, (void **) &$target, NULL))
    scm_wrong_type_arg(FUNC_NAME, $argnum, $source);
}

%typemap(out) SWIGTYPE * {
    $target = SWIG_Guile_MakePtr ($source, $descriptor);
}
    
%typemap(varout) SWIGTYPE * {
    $target = SWIG_Guile_MakePtr ($source, $descriptor);
}

/* Pass-by-value */

%typemap(in) SWIGTYPE($&1_ltype argp) {
  if (SWIG_Guile_GetPtr($input, (void **) &argp, $1_descriptor))
    scm_wrong_type_arg(FUNC_NAME,$argnum,$input);
  $1 = *argp;
}

%typemap(varin) SWIGTYPE($&1_ltype argp) {
  if (SWIG_Guile_GetPtr($input, (void **) &argp, $1_descriptor))
    scm_wrong_type_arg(FUNC_NAME,$argnum,$input);
  $1 = *argp;
}

%typemap(out) SWIGTYPE 
#ifdef __cplusplus
{
  $&1_ltype resultptr;
  resultptr = new $1_ltype($1);
  $result =  SWIG_Guile_MakePtr (resultptr, $&1_descriptor);
} 
#else
{
  $&1_ltype resultptr;
  resultptr = ($&1_ltype) malloc(sizeof($1_type));
  memmove(resultptr, &$1, sizeof($1_type));
  $result = SWIG_Guile_MakePtr(resultptr, $&1_descriptor);
}
#endif

%typemap(varout) SWIGTYPE 
#ifdef __cplusplus
{
  $&1_ltype resultptr;
  resultptr = new $1_ltype($1);
  $result =  SWIG_Guile_MakePtr (resultptr, $&1_descriptor);
} 
#else
{
  $&1_ltype resultptr;
  resultptr = ($&1_ltype) malloc(sizeof($1_type));
  memmove(resultptr, &$1, sizeof($1_type));
  $result = SWIG_Guile_MakePtr(resultptr, $&1_descriptor);
}
#endif

/* C++ References */

#ifdef __cplusplus

%typemap(in) SWIGTYPE & {
  if (SWIG_Guile_GetPtr($source, (void **) &$target, $descriptor)!=0)
    scm_wrong_type_arg(FUNC_NAME, $argnum, $source);
}

%typemap(out) SWIGTYPE & {
  $target = SWIG_Guile_MakePtr ($source, $descriptor);
}

#endif

/* Arrays */

%typemap(in) SWIGTYPE[] {
  if (SWIG_Guile_GetPtr($source, (void **) &$target, $descriptor)!=0)
    scm_wrong_type_arg(FUNC_NAME, $argnum, $source);
}

%typemap(out) SWIGTYPE[] {
  $target = SWIG_Guile_MakePtr ($source, $descriptor);
}

/* Enums */

%typemap(in)     enum SWIGTYPE "$target = gh_scm2int($source);";
%typemap(varin)  enum SWIGTYPE "$target = gh_scm2int($source);";
%typemap(out)    enum SWIGTYPE "$target = gh_int2scm($source);";
%typemap(varout) enum SWIGTYPE "$target = gh_int2scm($source);";

/* The SIMPLE_MAP macro below defines the whole set of typemaps needed
   for simple types. */

%define SIMPLE_MAP(C_NAME, SCM_TO_C, C_TO_SCM, SCM_NAME)
 %typemap (guile, in)          C_NAME, C_NAME const {$target = SCM_TO_C($source);}
 %typemap (guile, varin)       C_NAME, C_NAME const {$target = SCM_TO_C($source);}
 %typemap (guile, out)         C_NAME, C_NAME const {$target = C_TO_SCM($source);}
 %typemap (guile, varout)      C_NAME, C_NAME const {$target = C_TO_SCM($source);}
 %typemap (guile, indoc)       C_NAME, C_NAME const "($arg <SCM_NAME>)";
 %typemap (guile, varindoc)    C_NAME, C_NAME const "($arg <SCM_NAME>)";
 %typemap (guile, outdoc)      C_NAME, C_NAME const "<SCM_NAME>";
 %typemap (guile, varoutdoc)   C_NAME, C_NAME const "<SCM_NAME>";
 %typemap (guile, in)          C_NAME *INPUT(C_NAME temp) {
   temp = (C_NAME) SCM_TO_C($source); $target = &temp;
 }
 %typemap (guile, indoc)       C_NAME *INPUT "($arg <SCM_NAME>)";
 %typemap (guile, ignore)      C_NAME *OUTPUT (C_NAME temp)
   {$target = &temp;}
 %typemap (guile, argout)      C_NAME *OUTPUT
   {SWIG_APPEND_VALUE(C_TO_SCM(*$target));}
 %typemap (guile, argoutdoc)   C_NAME *OUTPUT "($arg <SCM_NAME>)";
 %typemap (guile, in)          C_NAME *BOTH = C_NAME *INPUT;
 %typemap (guile, indoc)       C_NAME *BOTH = C_NAME *INPUT;
 %typemap (guile, argout)      C_NAME *BOTH = C_NAME *OUTPUT;
 %typemap (guile, argoutdoc)   C_NAME *BOTH = C_NAME *OUTPUT;
 %typemap (guile, in)          C_NAME *INOUT = C_NAME *INPUT;
 %typemap (guile, indoc)       C_NAME *INOUT = C_NAME *INPUT;
 %typemap (guile, argout)      C_NAME *INOUT = C_NAME *OUTPUT;
 %typemap (guile, argoutdoc)   C_NAME *INOUT = C_NAME *OUTPUT;
%enddef

 SIMPLE_MAP(bool, gh_scm2bool, gh_bool2scm, boolean);
 SIMPLE_MAP(char, gh_scm2char, gh_char2scm, char);
 SIMPLE_MAP(unsigned char, gh_scm2char, gh_char2scm, char);
 SIMPLE_MAP(int, gh_scm2int, gh_int2scm, integer);
 SIMPLE_MAP(short, gh_scm2int, gh_int2scm, integer);
 SIMPLE_MAP(long, gh_scm2long, gh_long2scm, integer);
 SIMPLE_MAP(ptrdiff_t, gh_scm2long, gh_long2scm, integer);
 SIMPLE_MAP(unsigned int, gh_scm2ulong, gh_ulong2scm, integer);
 SIMPLE_MAP(unsigned short, gh_scm2ulong, gh_ulong2scm, integer);
 SIMPLE_MAP(unsigned long, gh_scm2ulong, gh_ulong2scm, integer);
 SIMPLE_MAP(size_t, gh_scm2ulong, gh_ulong2scm, integer);
 SIMPLE_MAP(float, gh_scm2double, gh_double2scm, real);
 SIMPLE_MAP(double, gh_scm2double, gh_double2scm, real);
 SIMPLE_MAP(char *, SWIG_scm2str, gh_str02scm, string);
 SIMPLE_MAP(const char *, SWIG_scm2str, gh_str02scm, string);

/* GSWIG_scm2str makes a malloc'ed copy of the string, so get rid of it after
   the function call. */

%typemap (guile, freearg) char *, const char * "if ($target) scm_must_free($target);";

%typemap (guile, freearg) char **OUTPUT, char **BOTH "if (*$target) scm_must_free(*$target);"

/* But this shall not apply if we try to pass a single char by
   reference. */

%typemap (guile, freearg) char *OUTPUT, char *BOTH "";

/* If we set a string variable, delete the old result first. */

%typemap (varin) char *, const char * {
    if ($target) free($target);
    $target = SWIG_scm2str($source);
}

/* Void */

%typemap (guile, out) void "gswig_result = GH_UNSPECIFIED;";
%typemap (guile, outdoc) void "";

/* SCM is passed through */

typedef unsigned long SCM;
%typemap (guile, in) SCM "$target=$source;";
%typemap (guile, out) SCM "$target=$source;";

/* typemaps.i ends here */
