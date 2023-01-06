OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
	onChipRam (rxa) : ORIGIN = 0x80000000, LENGTH = 4K
	sdram (wxa) : ORIGIN = 0x40000000, LENGTH = 64M
}

SECTIONS
{
	.init :
	{
		_text = .;
		KEEP (*(SORT_NONE(.init)))
	} >onChipRam AT>onChipRam
	
	.text :
	{
		*(.text.unlikely .text.unlikely.*)
		*(.text.startup .text.startup.*)
		*(.text .text.*)
		*(.gnu.linkonce.t.*)
	} >sdram AT>sdram
	
	.fini :
	{
		KEEP (*(SORT_NONE(.fini)))
		_etext = .;
	} >onChipRam AT>onChipRam

	.rodata.align :
	{
		. = ALIGN(4);
		_rodata = .;
	} >onChipRam AT>onChipRam

	.rodata.start :
	{
		_rodata_lma = LOADADDR(.rodata.start);
	} >onChipRam AT>onChipRam

	.rodata :
	{
		*(.rdata)
		*(.rodata .rodata.*)
		*(.gnu.linkonce.r.*)

		. = ALIGN(4);
		_erodata = .;
	} >onChipRam AT>onChipRam

	.data.align :
	{
		. = ALIGN(4);
		_data = .;
	} >sdram AT>onChipRam

	.data.start :
	{
		_data_lma = LOADADDR(.data.start);
	} >sdram AT>onChipRam

	.data :
	{
		*(.data .data.*)
		*(.gnu.linkonce.d.*)
		. = ALIGN(8);
		PROVIDE( __global_pointer$ = . + 0x800 );
		*(.sdata .sdata.*)
		*(.sdata2 .sdata2.*)
		*(.gnu.linkonce.s.*)
		. = ALIGN(8);
		*(.srodata.cst16)
		*(.srodata.cst8)
		*(.srodata.cst4)
		*(.srodata.cst2)
		*(.srodata .srodata.*)

		. = ALIGN(4);
		_edata = .;
	} >sdram AT>sdram

	.bss.align :
	{
		. = ALIGN(4);
		_bss = .;
	} >sdram AT>onChipRam

	.bss.start :
	{
		_bss_lma = LOADADDR(.bss.start);
	} >sdram AT>onChipRam

	.bss :
	{
		*(.sbss*)
		*(.gnu.linkonce.sb.*)
		*(.bss .bss.*)
		*(.gnu.linkonce.b.*)
		*(COMMON)

		. = ALIGN(4);
		_ebss = .;
	} >sdram AT>onChipRam

	. = ALIGN(8);
	_end = .;

	.stack :
	{
		. = ALIGN(16);
		. += __stack_size;
		_stack_top = .;
	} >sdram AT>sdram
}
