LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY MIC_Project_2 IS
	PORT (CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 AMUX  : IN STD_LOGIC;
		 ALU_SH   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 MBR   : IN STD_LOGIC;
		 MAR   : IN STD_LOGIC;
		 RD    : IN STD_LOGIC;
		 WR    : IN STD_LOGIC;
		 ENC   : IN STD_LOGIC;
		 C     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 B     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 A     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 --Conttrola o multiplexador que seleciona o endereço de leitura para o barramento A.
		A_BUS_LEITURA : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		--Conttrola o multiplexador que seleciona o endereço de leitura para o barramento B.
		B_BUS_LEITURA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		--Conttrola o multiplexador que seleciona o endereço de escrita a partir do barramento C.
		C_BUS_ESCRITA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA_OK : IN STD_LOGIC;
		
		MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		RD_OUTPUT : OUT STD_LOGIC;
		WR_OUTPUT : OUT STD_LOGIC;
		Z         : OUT STD_LOGIC;
		N         : OUT STD_LOGIC);
END MIC_Project_2;


ARCHITECTURE comportamental OF MIC_Project_2 IS
	
SIGNAL A_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL B_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL C_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL REG_MBR_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL REG_MBR_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL REG_MAR : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL RD_OUT, WR_OUT : STD_LOGIC;

	
COMPONENT MIC_Bank_Registers_2
	PORT (
		Reset : IN std_logic;
		Clk : IN std_logic;
		Enc : IN std_logic;
		A_Address : IN std_logic_vector(3 DOWNTO 0);
		B_Address : IN std_logic_vector(3 DOWNTO 0);
		C_Address : IN std_logic_vector(3 DOWNTO 0);
		LEITURA_A_BUS : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		LEITURA_B_BUS : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		ESCRITA_C_BUS : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		C_Input : IN std_logic_vector(15 DOWNTO 0);
		A_Output : OUT std_logic_vector(15 DOWNTO 0);
		B_Output : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


COMPONENT MIC_amux_alu_2
	PORT (
		amux : IN std_logic;
		alu_sh : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		A_Input : IN std_logic_vector(15 DOWNTO 0);
		B_Input : IN std_logic_vector(15 DOWNTO 0);
		MBR_Input : IN std_logic_vector(15 DOWNTO 0);
		N : OUT std_logic;
		Z : OUT std_logic;
		ALU_SH_Output : INOUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


BEGIN

-- GERAÇÃO DOS SINAIS DE SAÍDA
	MAR_OUTPUT <= REG_MAR(11 DOWNTO 0);
	MBR_TO_MEM <= REG_MBR_OUT(15 DOWNTO 0);
	WR_OUTPUT <= WR_OUT; -- Conteúdo do registrador escrito na saída
	RD_OUTPUT <= RD_OUT; -- Conteúdo do registrador escrito na saída
-- Sinais Z e N de saída são gerados no compomente MIC_amux_ula

--- INSTANCIAÇÃO DO COMPONENTE MIC_Banck_Register
Registers: MIC_Bank_Registers_2
PORT MAP (
	Reset => RESET, -- Segundo Reset é interface do MIC
	Clk => CLK, -- Segundo CLK é interface do MIC
	Enc => ENC, -- Segundo ENC é interface do MIC
	A_Address => A, -- A é interface do MIC
	B_Address => B, -- B é interface do MIC
	C_Address => C, -- C é interface do MIC
	LEITURA_A_BUS => A_BUS_LEITURA, -- A_BUS_LEITURA é interface do MIC
	LEITURA_B_BUS => B_BUS_LEITURA, -- B_BUS_LEITURA é interface do MIC
	ESCRITA_C_BUS => C_BUS_ESCRITA, -- C_BUS_ESCRITA é interface do MIC
	C_Input => C_BUS, -- C_BUS é sinal da arquitetura
	A_Output => A_BUS, -- A_BUS é sinal da arquitetura
	B_Output => B_BUS -- B_BUS é sinal da arquitetura
	);
	
	
--- INSTANCIAÇÃO DO COMPONENTE MIC_amux_alu
MUX_ALU_DESLOCADOR: MIC_amux_alu_2
PORT MAP (
	amux => AMUX, -- Segundo AMUX é interface do MIC
	alu_sh => ALU_SH, -- segundo ALU_SH é interface do MIC
	--sh => SH, -- segundo sinal é interface do MIC
	A_Input => A_BUS, -- segundo sinal é sinal deste arquivo
	B_Input => B_BUS, -- segundo sinal é sinal deste arquivo
	MBR_Input => REG_MBR_IN, -- REG_MBR_IN é sinal deste arquivo
	N => N, -- Segundo N é interface do MIC
	Z => Z, -- Segundo Z é interface do MIC
	ALU_SH_Output => C_BUS, -- C_BUS é sinal deste arquivo
	clk => CLK  -- Segundo CLK é interface do MIC
	);
	
	
--- IMPLEMENTAÇÃO DO REGISTRADOR REG_MAR
MAR_Process : PROCESS (Clk, Reset, MAR)
BEGIN
	IF Reset = '1' THEN
		REG_MAR <= "000000000000"; --(12 bits)
	ELSIF (rising_edge(Clk) AND MAR = '1') THEN
		REG_MAR <= B_BUS(11 DOWNTO 0);
	ELSE
		REG_MAR <= REG_MAR;
	END IF;
End Process MAR_Process;


--- IMPLEMENTAÇÃO DO REGISTRADOR REG_MBR_OUT
MBR_OUT_Process : PROCESS (Clk, Reset, MBR)
BEGIN
	IF Reset = '1' THEN
		REG_MBR_OUT <= "0000000000000000";
	ELSIF (rising_edge(Clk) AND MBR = '1') THEN
		REG_MBR_OUT <= C_BUS(15 DOWNTO 0);
	ELSE
		REG_MBR_OUT <= REG_MBR_OUT;
	END IF;
End Process MBR_OUT_Process;


--- IMPLEMENTAÇÃO DO REGISTRADOR REG_MBR_IN
MBR_IN_Process : PROCESS (Clk, Reset, DATA_OK)
BEGIN
	IF Reset = '1' THEN
		REG_MBR_IN <= "0000000000000000";
	ELSIF (rising_edge(Clk) AND DATA_OK = '1') THEN
		REG_MBR_IN <= MEM_TO_MBR(15 DOWNTO 0);
	ELSE
		REG_MBR_IN <= REG_MBR_IN;
	END IF;
End Process MBR_IN_Process;


--- IMPLEMENTAÇÃO DO REGISTRADOR RD
RD_OUT_Process : PROCESS (Clk, Reset, RD)
BEGIN
	IF Reset = '1' THEN
		RD_OUT <= '0';
	ELSIF (rising_edge(Clk)) THEN
		RD_OUT <= RD;
	ELSE
		RD_OUT <= RD_OUT;
	END IF;
End Process RD_OUT_Process;


--- IMPLEMENTAÇÃO DO REGISTRADOR WR
WR_OUT_Process : PROCESS (Clk, Reset, WR)
BEGIN
	IF Reset = '1' THEN
		WR_OUT <= '0';
	ELSIF (rising_edge(Clk)) THEN
		WR_OUT <= WR;
	ELSE
		WR_OUT <= WR_OUT;
	END IF;
End Process WR_OUT_Process;

END comportamental;