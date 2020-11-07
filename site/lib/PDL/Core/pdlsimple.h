
#ifndef __PDL_H

/* These are kept automaticallu in sync with pdl.h during perl build */


/*****************************************************************************/
/*** This section of .h file generated automatically by ***/
/*** PDL::Types::datatypes_header() - don't edit manually ***/

/* Data types/sizes [must be in order of complexity] */

typedef enum { PDL_INVALID=-1, PDL_B, PDL_S, PDL_US, PDL_L, PDL_IND, PDL_LL, PDL_F, PDL_D } pdl_datatypes;

/* Define the pdl data types */

typedef unsigned char              PDL_Byte;
typedef short              PDL_Short;
typedef unsigned short              PDL_Ushort;
typedef int              PDL_Long;
typedef long              PDL_Indx;
typedef long              PDL_LongLong;
typedef float              PDL_Float;
typedef double              PDL_Double;
typedef struct {
    pdl_datatypes type;
    union {
        PDL_Byte B;
        PDL_Short S;
        PDL_Ushort U;
        PDL_Long L;
        PDL_Indx N;
        PDL_LongLong Q;
        PDL_Float F;
        PDL_Double D;
    } value;
} PDL_Anyval;
#define IND_FLAG "ld"



/* typedef long    PDL_Indx; */

/*****************************************************************************/


#define PDL_U PDL_US
#define PDL_N PDL_IND
#define PDL_Q PDL_LL



#endif

/*
   Define a simple pdl C data structure which maps onto passed
   piddles for passing with callext().

   Note it is up to the user at the perl level to get the datatype
   right. Anything more sophisticated probably ought to go through
   PP anyway (which is fairly trivial).
*/

struct pdlsimple {
   int     datatype;  /* whether byte/int/float etc. */
   void       *data;  /* Generic pointer to the data block */
   PDL_Indx  nvals;  /* Number of data values */
   PDL_Indx  *dims;  /* Array of data dimensions */
   PDL_Long   ndims;  /* Number of data dimensions */
};

typedef struct pdlsimple pdlsimple;

