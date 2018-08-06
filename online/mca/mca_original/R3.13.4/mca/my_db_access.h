unsigned short dbr_status_offset[LAST_BUFFER_TYPE+1] = {
	0,					/* string			*/
	0,					/* short			*/
	0,					/* IEEE Float			*/
	0,					/* item number			*/
	0,					/* character			*/
	0,					/* long				*/
	0,					/* IEEE double			*/
	BYTE_OS(struct dbr_sts_string,status),/* string field	with status	*/
	BYTE_OS(struct dbr_sts_short,status),	/* short field with status	*/
	BYTE_OS(struct dbr_sts_float,status),	/* float field with status	*/
	BYTE_OS(struct dbr_sts_enum,status),	/* item number with status	*/
	BYTE_OS(struct dbr_sts_char,status),	/* char field with status	*/
	BYTE_OS(struct dbr_sts_long,status),	/* long field with status	*/
	BYTE_OS(struct dbr_sts_double,status),	/* double field with time	*/
	BYTE_OS(struct dbr_time_string,status),/* string field with time	*/
	BYTE_OS(struct dbr_time_short,status),	/* short field with time	*/
	BYTE_OS(struct dbr_time_float,status),	/* float field with time	*/
	BYTE_OS(struct dbr_time_enum,status),	/* item number with time	*/
	BYTE_OS(struct dbr_time_char,status),	/* char field with time		*/
	BYTE_OS(struct dbr_time_long,status),	/* long field with time		*/
	BYTE_OS(struct dbr_time_double,status),	/* double field with time	*/
	BYTE_OS(struct dbr_sts_string,status),/* graphic string info		*/
	BYTE_OS(struct dbr_gr_short,status),	/* graphic short info		*/
	BYTE_OS(struct dbr_gr_float,status),	/* graphic float info		*/
	BYTE_OS(struct dbr_gr_enum,status),	/* graphic item info		*/
	BYTE_OS(struct dbr_gr_char,status),	/* graphic char info		*/
	BYTE_OS(struct dbr_gr_long,status),	/* graphic long info		*/
	BYTE_OS(struct dbr_gr_double,status),	/* graphic double info		*/
	BYTE_OS(struct dbr_sts_string,status),/* control string info		*/
	BYTE_OS(struct dbr_ctrl_short,status),	/* control short info		*/
	BYTE_OS(struct dbr_ctrl_float,status),	/* control float info		*/
	BYTE_OS(struct dbr_ctrl_enum,status),	/* control item info		*/
	BYTE_OS(struct dbr_ctrl_char,status),	/* control char info		*/
	BYTE_OS(struct dbr_ctrl_long,status),	/* control long info		*/
	BYTE_OS(struct dbr_ctrl_double,status),	/* control double info		*/
	0,					/* put ackt			*/
	0,					/* put acks			*/
	BYTE_OS(struct dbr_stsack_string,status),/* string field	with status	*/
	0,					/* string			*/
};

unsigned short dbr_severity_offset[LAST_BUFFER_TYPE+1] = {
	0,					/* string			*/
	0,					/* short			*/
	0,					/* IEEE Float			*/
	0,					/* item number			*/
	0,					/* character			*/
	0,					/* long				*/
	0,					/* IEEE double			*/
	BYTE_OS(struct dbr_sts_string,severity),/* string field	with severity	*/
	BYTE_OS(struct dbr_sts_short,severity),	/* short field with severity	*/
	BYTE_OS(struct dbr_sts_float,severity),	/* float field with severity	*/
	BYTE_OS(struct dbr_sts_enum,severity),	/* item number with severity	*/
	BYTE_OS(struct dbr_sts_char,severity),	/* char field with severity	*/
	BYTE_OS(struct dbr_sts_long,severity),	/* long field with severity	*/
	BYTE_OS(struct dbr_sts_double,severity),	/* double field with time	*/
	BYTE_OS(struct dbr_time_string,severity),/* string field with time	*/
	BYTE_OS(struct dbr_time_short,severity),	/* short field with time	*/
	BYTE_OS(struct dbr_time_float,severity),	/* float field with time	*/
	BYTE_OS(struct dbr_time_enum,severity),	/* item number with time	*/
	BYTE_OS(struct dbr_time_char,severity),	/* char field with time		*/
	BYTE_OS(struct dbr_time_long,severity),	/* long field with time		*/
	BYTE_OS(struct dbr_time_double,severity),	/* double field with time	*/
	BYTE_OS(struct dbr_sts_string,severity),/* graphic string info		*/
	BYTE_OS(struct dbr_gr_short,severity),	/* graphic short info		*/
	BYTE_OS(struct dbr_gr_float,severity),	/* graphic float info		*/
	BYTE_OS(struct dbr_gr_enum,severity),	/* graphic item info		*/
	BYTE_OS(struct dbr_gr_char,severity),	/* graphic char info		*/
	BYTE_OS(struct dbr_gr_long,severity),	/* graphic long info		*/
	BYTE_OS(struct dbr_gr_double,severity),	/* graphic double info		*/
	BYTE_OS(struct dbr_sts_string,severity),/* control string info		*/
	BYTE_OS(struct dbr_ctrl_short,severity),	/* control short info		*/
	BYTE_OS(struct dbr_ctrl_float,severity),	/* control float info		*/
	BYTE_OS(struct dbr_ctrl_enum,severity),	/* control item info		*/
	BYTE_OS(struct dbr_ctrl_char,severity),	/* control char info		*/
	BYTE_OS(struct dbr_ctrl_long,severity),	/* control long info		*/
	BYTE_OS(struct dbr_ctrl_double,severity),	/* control double info		*/
	0,					/* put ackt			*/
	0,					/* put acks			*/
	BYTE_OS(struct dbr_stsack_string,severity),/* string field	with severity	*/
	0,					/* string			*/
};

unsigned short dbr_stamp_offset[LAST_BUFFER_TYPE+1] = {
	0,					/* string			*/
	0,					/* short			*/
	0,					/* IEEE Float			*/
	0,					/* item number			*/
	0,					/* character			*/
	0,					/* long				*/
	0,					/* IEEE double			*/
	0,/* string field	with stamp	*/
	0,	/* short field with stamp	*/
	0,	/* float field with stamp	*/
	0,	/* item number with stamp	*/
	0,	/* char field with stamp	*/
	0,	/* long field with stamp	*/
	0,	/* double field with time	*/
	BYTE_OS(struct dbr_time_string,stamp),/* string field with time	*/
	BYTE_OS(struct dbr_time_short,stamp),	/* short field with time	*/
	BYTE_OS(struct dbr_time_float,stamp),	/* float field with time	*/
	BYTE_OS(struct dbr_time_enum,stamp),	/* item number with time	*/
	BYTE_OS(struct dbr_time_char,stamp),	/* char field with time		*/
	BYTE_OS(struct dbr_time_long,stamp),	/* long field with time		*/
	BYTE_OS(struct dbr_time_double,stamp),	/* double field with time	*/
	0,/* graphic string info		*/
	0,	/* graphic short info		*/
	0,	/* graphic float info		*/
	0,	/* graphic item info		*/
	0,	/* graphic char info		*/
	0,	/* graphic long info		*/
	0,	/* graphic double info		*/
	0  ,/* control string info		*/
	0,	/* control short info		*/
	0,	/* control float info		*/
	0,	/* control char info		*/
	0,	/* control long info		*/
	0,	/* control double info		*/
	0,					/* put ackt			*/
	0,					/* put acks			*/
	0,/* string field	with stamp	*/
	0,					/* string			*/
};

#define dbr_stamp_ptr(PDBR, DBR_TYPE) \
((TS_STAMP *)(((char *)PDBR)+dbr_stamp_offset[DBR_TYPE]))

#define dbr_status_ptr(PDBR, DBR_TYPE) \
((dbr_short_t *)(((char *)PDBR)+dbr_status_offset[DBR_TYPE]))

#define dbr_severity_ptr(PDBR, DBR_TYPE) \
((dbr_short_t *)(((char *)PDBR)+dbr_severity_offset[DBR_TYPE]))