
#if defined(AIT_TO_NET_CONVERT)
static int aitConvertToNetInt8Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetInt8Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetUint8Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetUint8Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetInt16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetInt16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetUint16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetUint16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetEnum16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetEnum16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		temp=(aitEnum16)s_val[i];
		aitToNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&temp);
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertToNetInt32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetInt32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		temp=(aitInt32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetUint32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetUint32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		temp=(aitUint32)s_val[i];
		aitToNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetFloat32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat32)s_val[i];
		aitToNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&temp);
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFloat64Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt8* s_val=(aitInt8*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint8* s_val=(aitUint8*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		temp=(aitFloat64)s_val[i];
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&temp);
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFloat64Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		aitToNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
#elif defined(AIT_FROM_NET_CONVERT)
static int aitConvertFromNetInt8Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetInt8Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitInt8)temp;
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetUint8Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetUint8Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitUint8)temp;
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetInt16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		aitFromNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt16)temp;
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt16)temp;
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt16)temp;
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt16)temp;
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt16)temp;
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetInt16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitInt16)temp;
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetUint16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint16)temp;
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		aitFromNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint16)temp;
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint16)temp;
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint16)temp;
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint16)temp;
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetUint16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitUint16)temp;
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetEnum16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitEnum16)temp;
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitEnum16)temp;
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		aitFromNetOrder16((aitUint16*)&d_val[i],(aitUint16*)&s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitEnum16)temp;
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitEnum16)temp;
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitEnum16)temp;
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetEnum16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitEnum16)temp;
	}
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertFromNetInt32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt32)temp;
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt32)temp;
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitInt32)temp;
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		aitFromNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt32)temp;
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitInt32)temp;
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetInt32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitInt32)temp;
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetUint32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint32)temp;
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint32)temp;
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitUint32)temp;
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint32)temp;
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		aitFromNetOrder32((aitUint32*)&d_val[i],(aitUint32*)&s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitUint32)temp;
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetUint32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitUint32)temp;
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetFloat32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitFloat32)temp;
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitFloat32)temp;
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitFloat32)temp;
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitFloat32)temp;
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitFloat32)temp;
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		aitFromNetFloat32((aitUint32*)&d_val[i],(aitUint32*)&s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	aitFloat64 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat64((aitUint64*)&temp,(aitUint64*)&s_val[i]);
		d_val[i]=(aitFloat32)temp;
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFloat64Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt16* s_val=(aitInt16*)s;

	aitInt16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitFloat64)temp;
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint16* s_val=(aitUint16*)s;

	aitUint16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitFloat64)temp;
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	aitEnum16 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder16((aitUint16*)&temp,(aitUint16*)&s_val[i]);
		d_val[i]=(aitFloat64)temp;
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt32* s_val=(aitInt32*)s;

	aitInt32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitFloat64)temp;
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint32* s_val=(aitUint32*)s;

	aitUint32 temp;

	for(i=0;i<c;i++) {
		aitFromNetOrder32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitFloat64)temp;
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	aitFloat32 temp;

	for(i=0;i<c;i++) {
		aitFromNetFloat32((aitUint32*)&temp,(aitUint32*)&s_val[i]);
		d_val[i]=(aitFloat64)temp;
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFloat64Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		aitFromNetFloat64((aitUint64*)&d_val[i],(aitUint64*)&s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
#else /* AIT_CONVERT */
static int aitConvertInt8Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitInt8));
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertInt8Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt8* d_val=(aitInt8*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt8)(s_val[i]);
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertUint8Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitUint8));
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertUint8Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint8* d_val=(aitUint8*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint8)(s_val[i]);
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertInt16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitInt16));
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertInt16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt16* d_val=(aitInt16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt16)(s_val[i]);
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertUint16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitUint16));
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertUint16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint16* d_val=(aitUint16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint16)(s_val[i]);
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertEnum16Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitEnum16));
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertEnum16Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitEnum16* d_val=(aitEnum16*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitEnum16)(s_val[i]);
	return (int) (sizeof(aitEnum16)*c);
}
static int aitConvertInt32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitInt32));
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertInt32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitInt32* d_val=(aitInt32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitInt32)(s_val[i]);
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertUint32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitUint32));
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertUint32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitUint32* d_val=(aitUint32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitUint32)(s_val[i]);
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFloat32Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitFloat32));
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat32Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat32* d_val=(aitFloat32*)d;
	aitFloat64* s_val=(aitFloat64*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat32)(s_val[i]);
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFloat64Int8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt8* s_val=(aitInt8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Uint8(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint8* s_val=(aitUint8*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Int16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt16* s_val=(aitInt16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Uint16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint16* s_val=(aitUint16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Enum16(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitEnum16* s_val=(aitEnum16*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Int32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitInt32* s_val=(aitInt32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Uint32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitUint32* s_val=(aitUint32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Float32(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	aitIndex i;
	aitFloat64* d_val=(aitFloat64*)d;
	aitFloat32* s_val=(aitFloat32*)s;

	for(i=0;i<c;i++)
		d_val[i]=(aitFloat64)(s_val[i]);
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFloat64Float64(void* d,const void* s,aitIndex c, const gddEnumStringTable *)
{
	memcpy(d,s,c*sizeof(aitFloat64));
	return (int) (sizeof(aitFloat64)*c);
}
#endif

#if defined(AIT_TO_NET_CONVERT)
static int aitConvertToNetInt8String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt8* out=(aitInt8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-128 && ftmp<=127) {
				out[i] = (aitInt8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetStringInt8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt8* in=(aitInt8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetInt8FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt8* out=(aitInt8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-128 && ftmp<=127) {
				out[i] = (aitInt8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertToNetFixedStringInt8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt8* in=(aitInt8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetUint8String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint8* out=(aitUint8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=255) {
				out[i] = (aitUint8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetStringUint8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint8* in=(aitUint8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetUint8FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint8* out=(aitUint8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=255) {
				out[i] = (aitUint8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertToNetFixedStringUint8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint8* in=(aitUint8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetInt16String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt16* out=(aitInt16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-32768 && ftmp<=32767) {
				out[i] = (aitInt16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetStringInt16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt16* in=(aitInt16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetInt16FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt16* out=(aitInt16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-32768 && ftmp<=32767) {
				out[i] = (aitInt16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertToNetFixedStringInt16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt16* in=(aitInt16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetUint16String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint16* out=(aitUint16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=65535) {
				out[i] = (aitUint16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetStringUint16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint16* in=(aitUint16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetUint16FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint16* out=(aitUint16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=65535) {
				out[i] = (aitUint16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertToNetFixedStringUint16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint16* in=(aitUint16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetInt32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt32* out=(aitInt32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-2.14748e+09 && ftmp<=2.14748e+09) {
				out[i] = (aitInt32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetStringInt32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt32* in=(aitInt32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetInt32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt32* out=(aitInt32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-2.14748e+09 && ftmp<=2.14748e+09) {
				out[i] = (aitInt32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertToNetFixedStringInt32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt32* in=(aitInt32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetUint32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint32* out=(aitUint32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=4.29497e+09) {
				out[i] = (aitUint32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetStringUint32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint32* in=(aitUint32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetUint32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint32* out=(aitUint32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=4.29497e+09) {
				out[i] = (aitUint32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertToNetFixedStringUint32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint32* in=(aitUint32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetFloat32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitFloat32* out=(aitFloat32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-3.40282e+38 && ftmp<=3.40282e+38) {
				out[i] = (aitFloat32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetStringFloat32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitFloat32* in=(aitFloat32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetFloat32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitFloat32* out=(aitFloat32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-3.40282e+38 && ftmp<=3.40282e+38) {
				out[i] = (aitFloat32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertToNetFixedStringFloat32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitFloat32* in=(aitFloat32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetFloat64String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitFloat64* out=(aitFloat64*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-1.79769e+308 && ftmp<=1.79769e+308) {
				out[i] = (aitFloat64) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetStringFloat64(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitFloat64* in=(aitFloat64*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertToNetFloat64FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitFloat64* out=(aitFloat64*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-1.79769e+308 && ftmp<=1.79769e+308) {
				out[i] = (aitFloat64) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertToNetFixedStringFloat64(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitFloat64* in=(aitFloat64*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
#elif defined(AIT_FROM_NET_CONVERT)
static int aitConvertFromNetInt8String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt8* out=(aitInt8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-128 && ftmp<=127) {
				out[i] = (aitInt8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetStringInt8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt8* in=(aitInt8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetInt8FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt8* out=(aitInt8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-128 && ftmp<=127) {
				out[i] = (aitInt8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFromNetFixedStringInt8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt8* in=(aitInt8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetUint8String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint8* out=(aitUint8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=255) {
				out[i] = (aitUint8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetStringUint8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint8* in=(aitUint8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetUint8FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint8* out=(aitUint8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=255) {
				out[i] = (aitUint8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFromNetFixedStringUint8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint8* in=(aitUint8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetInt16String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt16* out=(aitInt16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-32768 && ftmp<=32767) {
				out[i] = (aitInt16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetStringInt16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt16* in=(aitInt16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetInt16FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt16* out=(aitInt16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-32768 && ftmp<=32767) {
				out[i] = (aitInt16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFromNetFixedStringInt16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt16* in=(aitInt16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetUint16String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint16* out=(aitUint16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=65535) {
				out[i] = (aitUint16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetStringUint16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint16* in=(aitUint16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetUint16FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint16* out=(aitUint16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=65535) {
				out[i] = (aitUint16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFromNetFixedStringUint16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint16* in=(aitUint16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetInt32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt32* out=(aitInt32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-2.14748e+09 && ftmp<=2.14748e+09) {
				out[i] = (aitInt32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetStringInt32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt32* in=(aitInt32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetInt32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt32* out=(aitInt32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-2.14748e+09 && ftmp<=2.14748e+09) {
				out[i] = (aitInt32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFromNetFixedStringInt32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt32* in=(aitInt32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetUint32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint32* out=(aitUint32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=4.29497e+09) {
				out[i] = (aitUint32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetStringUint32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint32* in=(aitUint32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetUint32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint32* out=(aitUint32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=4.29497e+09) {
				out[i] = (aitUint32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFromNetFixedStringUint32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint32* in=(aitUint32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetFloat32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitFloat32* out=(aitFloat32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-3.40282e+38 && ftmp<=3.40282e+38) {
				out[i] = (aitFloat32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetStringFloat32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitFloat32* in=(aitFloat32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetFloat32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitFloat32* out=(aitFloat32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-3.40282e+38 && ftmp<=3.40282e+38) {
				out[i] = (aitFloat32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFromNetFixedStringFloat32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitFloat32* in=(aitFloat32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetFloat64String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitFloat64* out=(aitFloat64*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-1.79769e+308 && ftmp<=1.79769e+308) {
				out[i] = (aitFloat64) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetStringFloat64(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitFloat64* in=(aitFloat64*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFromNetFloat64FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitFloat64* out=(aitFloat64*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-1.79769e+308 && ftmp<=1.79769e+308) {
				out[i] = (aitFloat64) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFromNetFixedStringFloat64(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitFloat64* in=(aitFloat64*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
#else /* AIT_CONVERT */
static int aitConvertInt8String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt8* out=(aitInt8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-128 && ftmp<=127) {
				out[i] = (aitInt8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertStringInt8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt8* in=(aitInt8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertInt8FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt8* out=(aitInt8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-128 && ftmp<=127) {
				out[i] = (aitInt8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt8)*c);
}
static int aitConvertFixedStringInt8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt8* in=(aitInt8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertUint8String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint8* out=(aitUint8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=255) {
				out[i] = (aitUint8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertStringUint8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint8* in=(aitUint8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertUint8FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint8* out=(aitUint8*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=255) {
				out[i] = (aitUint8) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint8)*c);
}
static int aitConvertFixedStringUint8(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint8* in=(aitUint8*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertInt16String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt16* out=(aitInt16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-32768 && ftmp<=32767) {
				out[i] = (aitInt16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertStringInt16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt16* in=(aitInt16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertInt16FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt16* out=(aitInt16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-32768 && ftmp<=32767) {
				out[i] = (aitInt16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt16)*c);
}
static int aitConvertFixedStringInt16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt16* in=(aitInt16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertUint16String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint16* out=(aitUint16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=65535) {
				out[i] = (aitUint16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertStringUint16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint16* in=(aitUint16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertUint16FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint16* out=(aitUint16*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=65535) {
				out[i] = (aitUint16) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint16)*c);
}
static int aitConvertFixedStringUint16(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint16* in=(aitUint16*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertInt32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitInt32* out=(aitInt32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-2.14748e+09 && ftmp<=2.14748e+09) {
				out[i] = (aitInt32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertStringInt32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitInt32* in=(aitInt32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertInt32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitInt32* out=(aitInt32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-2.14748e+09 && ftmp<=2.14748e+09) {
				out[i] = (aitInt32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitInt32)*c);
}
static int aitConvertFixedStringInt32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitInt32* in=(aitInt32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertUint32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitUint32* out=(aitUint32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=4.29497e+09) {
				out[i] = (aitUint32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertStringUint32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitUint32* in=(aitUint32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertUint32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitUint32* out=(aitUint32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=0 && ftmp<=4.29497e+09) {
				out[i] = (aitUint32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitUint32)*c);
}
static int aitConvertFixedStringUint32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitUint32* in=(aitUint32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFloat32String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitFloat32* out=(aitFloat32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-3.40282e+38 && ftmp<=3.40282e+38) {
				out[i] = (aitFloat32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertStringFloat32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitFloat32* in=(aitFloat32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFloat32FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitFloat32* out=(aitFloat32*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-3.40282e+38 && ftmp<=3.40282e+38) {
				out[i] = (aitFloat32) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat32)*c);
}
static int aitConvertFixedStringFloat32(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitFloat32* in=(aitFloat32*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFloat64String(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitString* in=(aitString*)s;
	aitFloat64* out=(aitFloat64*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].string(), pEST, ftmp) ) {
			if (ftmp>=-1.79769e+308 && ftmp<=1.79769e+308) {
				out[i] = (aitFloat64) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertStringFloat64(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	char temp[AIT_FIXED_STRING_SIZE];
	aitString* out=(aitString*)d;
	aitFloat64* in=(aitFloat64*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( putDoubleToString ( in[i], pEST, temp, AIT_FIXED_STRING_SIZE ) ) {
			out[i].copy ( temp );
		}
		else {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
static int aitConvertFloat64FixedString(void* d,const void* s,aitIndex c, const gddEnumStringTable *pEST)
{
	aitFixedString* in=(aitFixedString*)s;
	aitFloat64* out=(aitFloat64*)d;
	for(aitIndex i=0;i<c;i++) {
		double ftmp;
		if ( getStringAsDouble (in[i].fixed_string, pEST, ftmp) ) {
			if (ftmp>=-1.79769e+308 && ftmp<=1.79769e+308) {
				out[i] = (aitFloat64) ftmp;
			}
			else {
				return -1;
			}
		}
		else {
			return -1;
		}
	}
	return (int) (sizeof(aitFloat64)*c);
}
static int aitConvertFixedStringFloat64(void* d,const void* s,aitIndex c, const gddEnumStringTable * pEST)
{
	aitFixedString* out=(aitFixedString*)d;
	aitFloat64* in=(aitFloat64*)s;
	for(aitIndex i=0;i<c;i++) {
		if ( ! putDoubleToString ( in[i], pEST, out[i].fixed_string, AIT_FIXED_STRING_SIZE ) ) {
			return -1;
		}
	}
	return c*AIT_FIXED_STRING_SIZE;
}
#endif

#if defined(AIT_TO_NET_CONVERT)
aitFunc aitConvertToNetTable[aitTotal][aitTotal]={
 {
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetInt8Int8,
aitConvertToNetInt8Uint8,aitConvertToNetInt8Int16,
aitConvertToNetInt8Uint16,aitConvertToNetInt8Enum16,
aitConvertToNetInt8Int32,aitConvertToNetInt8Uint32,
aitConvertToNetInt8Float32,aitConvertToNetInt8Float64,
aitConvertToNetInt8FixedString,aitConvertToNetInt8String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetUint8Int8,
aitConvertToNetUint8Uint8,aitConvertToNetUint8Int16,
aitConvertToNetUint8Uint16,aitConvertToNetUint8Enum16,
aitConvertToNetUint8Int32,aitConvertToNetUint8Uint32,
aitConvertToNetUint8Float32,aitConvertToNetUint8Float64,
aitConvertToNetUint8FixedString,aitConvertToNetUint8String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetInt16Int8,
aitConvertToNetInt16Uint8,aitConvertToNetInt16Int16,
aitConvertToNetInt16Uint16,aitConvertToNetInt16Enum16,
aitConvertToNetInt16Int32,aitConvertToNetInt16Uint32,
aitConvertToNetInt16Float32,aitConvertToNetInt16Float64,
aitConvertToNetInt16FixedString,aitConvertToNetInt16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetUint16Int8,
aitConvertToNetUint16Uint8,aitConvertToNetUint16Int16,
aitConvertToNetUint16Uint16,aitConvertToNetUint16Enum16,
aitConvertToNetUint16Int32,aitConvertToNetUint16Uint32,
aitConvertToNetUint16Float32,aitConvertToNetUint16Float64,
aitConvertToNetUint16FixedString,aitConvertToNetUint16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetEnum16Int8,
aitConvertToNetEnum16Uint8,aitConvertToNetEnum16Int16,
aitConvertToNetEnum16Uint16,aitConvertToNetEnum16Enum16,
aitConvertToNetEnum16Int32,aitConvertToNetEnum16Uint32,
aitConvertToNetEnum16Float32,aitConvertToNetEnum16Float64,
aitConvertToNetEnum16FixedString,aitConvertToNetEnum16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetInt32Int8,
aitConvertToNetInt32Uint8,aitConvertToNetInt32Int16,
aitConvertToNetInt32Uint16,aitConvertToNetInt32Enum16,
aitConvertToNetInt32Int32,aitConvertToNetInt32Uint32,
aitConvertToNetInt32Float32,aitConvertToNetInt32Float64,
aitConvertToNetInt32FixedString,aitConvertToNetInt32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetUint32Int8,
aitConvertToNetUint32Uint8,aitConvertToNetUint32Int16,
aitConvertToNetUint32Uint16,aitConvertToNetUint32Enum16,
aitConvertToNetUint32Int32,aitConvertToNetUint32Uint32,
aitConvertToNetUint32Float32,aitConvertToNetUint32Float64,
aitConvertToNetUint32FixedString,aitConvertToNetUint32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetFloat32Int8,
aitConvertToNetFloat32Uint8,aitConvertToNetFloat32Int16,
aitConvertToNetFloat32Uint16,aitConvertToNetFloat32Enum16,
aitConvertToNetFloat32Int32,aitConvertToNetFloat32Uint32,
aitConvertToNetFloat32Float32,aitConvertToNetFloat32Float64,
aitConvertToNetFloat32FixedString,aitConvertToNetFloat32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetFloat64Int8,
aitConvertToNetFloat64Uint8,aitConvertToNetFloat64Int16,
aitConvertToNetFloat64Uint16,aitConvertToNetFloat64Enum16,
aitConvertToNetFloat64Int32,aitConvertToNetFloat64Uint32,
aitConvertToNetFloat64Float32,aitConvertToNetFloat64Float64,
aitConvertToNetFloat64FixedString,aitConvertToNetFloat64String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetFixedStringInt8,
aitConvertToNetFixedStringUint8,aitConvertToNetFixedStringInt16,
aitConvertToNetFixedStringUint16,aitConvertToNetFixedStringEnum16,
aitConvertToNetFixedStringInt32,aitConvertToNetFixedStringUint32,
aitConvertToNetFixedStringFloat32,aitConvertToNetFixedStringFloat64,
aitConvertToNetFixedStringFixedString,aitConvertToNetFixedStringString,
aitNoConvert
 },
 {
aitNoConvert,aitConvertToNetStringInt8,
aitConvertToNetStringUint8,aitConvertToNetStringInt16,
aitConvertToNetStringUint16,aitConvertToNetStringEnum16,
aitConvertToNetStringInt32,aitConvertToNetStringUint32,
aitConvertToNetStringFloat32,aitConvertToNetStringFloat64,
aitConvertToNetStringFixedString,aitConvertToNetStringString,
aitNoConvert
 },
 {
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert
 }
};

#elif defined(AIT_FROM_NET_CONVERT)
aitFunc aitConvertFromNetTable[aitTotal][aitTotal]={
 {
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetInt8Int8,
aitConvertFromNetInt8Uint8,aitConvertFromNetInt8Int16,
aitConvertFromNetInt8Uint16,aitConvertFromNetInt8Enum16,
aitConvertFromNetInt8Int32,aitConvertFromNetInt8Uint32,
aitConvertFromNetInt8Float32,aitConvertFromNetInt8Float64,
aitConvertFromNetInt8FixedString,aitConvertFromNetInt8String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetUint8Int8,
aitConvertFromNetUint8Uint8,aitConvertFromNetUint8Int16,
aitConvertFromNetUint8Uint16,aitConvertFromNetUint8Enum16,
aitConvertFromNetUint8Int32,aitConvertFromNetUint8Uint32,
aitConvertFromNetUint8Float32,aitConvertFromNetUint8Float64,
aitConvertFromNetUint8FixedString,aitConvertFromNetUint8String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetInt16Int8,
aitConvertFromNetInt16Uint8,aitConvertFromNetInt16Int16,
aitConvertFromNetInt16Uint16,aitConvertFromNetInt16Enum16,
aitConvertFromNetInt16Int32,aitConvertFromNetInt16Uint32,
aitConvertFromNetInt16Float32,aitConvertFromNetInt16Float64,
aitConvertFromNetInt16FixedString,aitConvertFromNetInt16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetUint16Int8,
aitConvertFromNetUint16Uint8,aitConvertFromNetUint16Int16,
aitConvertFromNetUint16Uint16,aitConvertFromNetUint16Enum16,
aitConvertFromNetUint16Int32,aitConvertFromNetUint16Uint32,
aitConvertFromNetUint16Float32,aitConvertFromNetUint16Float64,
aitConvertFromNetUint16FixedString,aitConvertFromNetUint16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetEnum16Int8,
aitConvertFromNetEnum16Uint8,aitConvertFromNetEnum16Int16,
aitConvertFromNetEnum16Uint16,aitConvertFromNetEnum16Enum16,
aitConvertFromNetEnum16Int32,aitConvertFromNetEnum16Uint32,
aitConvertFromNetEnum16Float32,aitConvertFromNetEnum16Float64,
aitConvertFromNetEnum16FixedString,aitConvertFromNetEnum16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetInt32Int8,
aitConvertFromNetInt32Uint8,aitConvertFromNetInt32Int16,
aitConvertFromNetInt32Uint16,aitConvertFromNetInt32Enum16,
aitConvertFromNetInt32Int32,aitConvertFromNetInt32Uint32,
aitConvertFromNetInt32Float32,aitConvertFromNetInt32Float64,
aitConvertFromNetInt32FixedString,aitConvertFromNetInt32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetUint32Int8,
aitConvertFromNetUint32Uint8,aitConvertFromNetUint32Int16,
aitConvertFromNetUint32Uint16,aitConvertFromNetUint32Enum16,
aitConvertFromNetUint32Int32,aitConvertFromNetUint32Uint32,
aitConvertFromNetUint32Float32,aitConvertFromNetUint32Float64,
aitConvertFromNetUint32FixedString,aitConvertFromNetUint32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetFloat32Int8,
aitConvertFromNetFloat32Uint8,aitConvertFromNetFloat32Int16,
aitConvertFromNetFloat32Uint16,aitConvertFromNetFloat32Enum16,
aitConvertFromNetFloat32Int32,aitConvertFromNetFloat32Uint32,
aitConvertFromNetFloat32Float32,aitConvertFromNetFloat32Float64,
aitConvertFromNetFloat32FixedString,aitConvertFromNetFloat32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetFloat64Int8,
aitConvertFromNetFloat64Uint8,aitConvertFromNetFloat64Int16,
aitConvertFromNetFloat64Uint16,aitConvertFromNetFloat64Enum16,
aitConvertFromNetFloat64Int32,aitConvertFromNetFloat64Uint32,
aitConvertFromNetFloat64Float32,aitConvertFromNetFloat64Float64,
aitConvertFromNetFloat64FixedString,aitConvertFromNetFloat64String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetFixedStringInt8,
aitConvertFromNetFixedStringUint8,aitConvertFromNetFixedStringInt16,
aitConvertFromNetFixedStringUint16,aitConvertFromNetFixedStringEnum16,
aitConvertFromNetFixedStringInt32,aitConvertFromNetFixedStringUint32,
aitConvertFromNetFixedStringFloat32,aitConvertFromNetFixedStringFloat64,
aitConvertFromNetFixedStringFixedString,aitConvertFromNetFixedStringString,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFromNetStringInt8,
aitConvertFromNetStringUint8,aitConvertFromNetStringInt16,
aitConvertFromNetStringUint16,aitConvertFromNetStringEnum16,
aitConvertFromNetStringInt32,aitConvertFromNetStringUint32,
aitConvertFromNetStringFloat32,aitConvertFromNetStringFloat64,
aitConvertFromNetStringFixedString,aitConvertFromNetStringString,
aitNoConvert
 },
 {
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert
 }
};

#else /* AIT_CONVERT */
aitFunc aitConvertTable[aitTotal][aitTotal]={
 {
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert
 },
 {
aitNoConvert,aitConvertInt8Int8,
aitConvertInt8Uint8,aitConvertInt8Int16,
aitConvertInt8Uint16,aitConvertInt8Enum16,
aitConvertInt8Int32,aitConvertInt8Uint32,
aitConvertInt8Float32,aitConvertInt8Float64,
aitConvertInt8FixedString,aitConvertInt8String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertUint8Int8,
aitConvertUint8Uint8,aitConvertUint8Int16,
aitConvertUint8Uint16,aitConvertUint8Enum16,
aitConvertUint8Int32,aitConvertUint8Uint32,
aitConvertUint8Float32,aitConvertUint8Float64,
aitConvertUint8FixedString,aitConvertUint8String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertInt16Int8,
aitConvertInt16Uint8,aitConvertInt16Int16,
aitConvertInt16Uint16,aitConvertInt16Enum16,
aitConvertInt16Int32,aitConvertInt16Uint32,
aitConvertInt16Float32,aitConvertInt16Float64,
aitConvertInt16FixedString,aitConvertInt16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertUint16Int8,
aitConvertUint16Uint8,aitConvertUint16Int16,
aitConvertUint16Uint16,aitConvertUint16Enum16,
aitConvertUint16Int32,aitConvertUint16Uint32,
aitConvertUint16Float32,aitConvertUint16Float64,
aitConvertUint16FixedString,aitConvertUint16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertEnum16Int8,
aitConvertEnum16Uint8,aitConvertEnum16Int16,
aitConvertEnum16Uint16,aitConvertEnum16Enum16,
aitConvertEnum16Int32,aitConvertEnum16Uint32,
aitConvertEnum16Float32,aitConvertEnum16Float64,
aitConvertEnum16FixedString,aitConvertEnum16String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertInt32Int8,
aitConvertInt32Uint8,aitConvertInt32Int16,
aitConvertInt32Uint16,aitConvertInt32Enum16,
aitConvertInt32Int32,aitConvertInt32Uint32,
aitConvertInt32Float32,aitConvertInt32Float64,
aitConvertInt32FixedString,aitConvertInt32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertUint32Int8,
aitConvertUint32Uint8,aitConvertUint32Int16,
aitConvertUint32Uint16,aitConvertUint32Enum16,
aitConvertUint32Int32,aitConvertUint32Uint32,
aitConvertUint32Float32,aitConvertUint32Float64,
aitConvertUint32FixedString,aitConvertUint32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFloat32Int8,
aitConvertFloat32Uint8,aitConvertFloat32Int16,
aitConvertFloat32Uint16,aitConvertFloat32Enum16,
aitConvertFloat32Int32,aitConvertFloat32Uint32,
aitConvertFloat32Float32,aitConvertFloat32Float64,
aitConvertFloat32FixedString,aitConvertFloat32String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFloat64Int8,
aitConvertFloat64Uint8,aitConvertFloat64Int16,
aitConvertFloat64Uint16,aitConvertFloat64Enum16,
aitConvertFloat64Int32,aitConvertFloat64Uint32,
aitConvertFloat64Float32,aitConvertFloat64Float64,
aitConvertFloat64FixedString,aitConvertFloat64String,
aitNoConvert
 },
 {
aitNoConvert,aitConvertFixedStringInt8,
aitConvertFixedStringUint8,aitConvertFixedStringInt16,
aitConvertFixedStringUint16,aitConvertFixedStringEnum16,
aitConvertFixedStringInt32,aitConvertFixedStringUint32,
aitConvertFixedStringFloat32,aitConvertFixedStringFloat64,
aitConvertFixedStringFixedString,aitConvertFixedStringString,
aitNoConvert
 },
 {
aitNoConvert,aitConvertStringInt8,
aitConvertStringUint8,aitConvertStringInt16,
aitConvertStringUint16,aitConvertStringEnum16,
aitConvertStringInt32,aitConvertStringUint32,
aitConvertStringFloat32,aitConvertStringFloat64,
aitConvertStringFixedString,aitConvertStringString,
aitNoConvert
 },
 {
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert,aitNoConvert,
aitNoConvert
 }
};

#endif
