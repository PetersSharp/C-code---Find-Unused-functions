//--------------------------------------------------------------------------------------
//
//    See: Find-Unused.sh
//
//        Required:
//
//        - GCC 4.x
//        - nm (any version)
//        - find :)
//
//        Use:
//
//        - add CFLAGS:  -ffunction-sections -fdata-sections
//        - add LDFLAGS: -Wl,-gc-sections
//        - (optionals) add to source file: #include "find-unused.h",
//          and add prefix you export functions: FUNINLINE or FUNEXPORT (Required find-unused.h)
//        to Makefile, and make source
//        after run: ./Find-Unused.sh <path/compiled-name.bin> <path/object-dir/*.o> [<path/source-dir/*.c|h>]
//
//    You can find latest source:
//     - https://github.com/PetersSharp/C-code---Find-Unused-functions
//
//    * $Id$
//    * commit date: $Format:%cd by %aN$
//
//--------------------------------------------------------------------------------------

#ifndef DEBUG_FIND_UNUSED_H
#define DEBUG_FIND_UNUSED_H

# if defined(__GNUC__) || defined(__GCC__)
#    if (!defined(__GNUC_STDC_INLINE__) && !defined(__GNUC_GNU_INLINE__))
#         define FUNINLINE static inline __attribute__((always_inline))
#    else
#         define FUNINLINE static inline
#    endif
#    define FUNEXPORT
#    // define FUNEXPORT __attribute__((visibility("default"))) /* error if latest gcc ??? */
# else
#    define FUNINLINE inline
#    define FUNEXPORT
# endif

#endif
