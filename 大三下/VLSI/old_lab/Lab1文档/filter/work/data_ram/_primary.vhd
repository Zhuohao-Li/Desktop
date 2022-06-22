library verilog;
use verilog.vl_types.all;
entity data_ram is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_in_en      : in     vl_logic;
        data_counter    : in     vl_logic_vector(4 downto 0);
        data_in         : in     vl_logic_vector(15 downto 0);
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end data_ram;
