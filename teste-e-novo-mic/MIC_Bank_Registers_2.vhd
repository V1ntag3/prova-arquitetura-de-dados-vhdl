LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY MIC_Bank_Registers_2 IS
PORT (
	Reset		: IN std_logic;
	Clk		: IN std_logic;
	Enc		: IN std_logic;
	A_Address	: IN std_logic_vector(3 DOWNTO 0);
	B_Address	: IN std_logic_vector(3 DOWNTO 0);
	C_Address	: IN std_logic_vector(3 DOWNTO 0);
	--COntrolam os multiplexadores Mux 1, 2 e 3.
	LEITURA_A_BUS : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
	LEITURA_B_BUS : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	ESCRITA_C_BUS : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	C_Input		: IN std_logic_vector(15 DOWNTO 0);
	
	A_Output	: OUT std_logic_vector(15 DOWNTO 0);
	B_Output	: OUT std_logic_vector(15 DOWNTO 0));
END MIC_Bank_Registers_2;

ARCHITECTURE behavioral OF MIC_Bank_Registers_2 IS

TYPE BANKREG is array(0 to 15) of STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL Bank_Register : BANKREG;

SIGNAL MUX_1 : std_logic_vector(3 DOWNTO 0);
SIGNAL MUX_2 : std_logic_vector(3 DOWNTO 0);
SIGNAL MUX_3 : std_logic_vector(3 DOWNTO 0);

BEGIN

	
--MULTIPLEXADOR 1: '00' OU '11' SELECIONA O SINAL 'A' PARA LEITURA, '01' SELECIONA RA E '10' RB. 
WITH LEITURA_A_BUS SELECT
	MUX_1 <= A_Address(3 DOWNTO 0) WHEN "00",
	Bank_Register(3)(7 DOWNTO 4) WHEN "01",
	Bank_Register(3)(3 DOWNTO 0) WHEN "10",
	A_Address(3 DOWNTO 0) WHEN OTHERS;
	
--MULTIPLEXADOR 2: '00' OU '11' SELECIONA O SINAL 'B' PARA LEITURA, '01' SELECIONA RA E '10' RB. 
WITH LEITURA_B_BUS SELECT
	MUX_2 <= B_Address(3 DOWNTO 0) WHEN "00",
	Bank_Register(3)(7 DOWNTO 4) WHEN "01",
	Bank_Register(3)(3 DOWNTO 0) WHEN "10",
	B_Address(3 DOWNTO 0) WHEN OTHERS;
	
--MULTIPLEXADOR 3: '00' OU '11' SELECIONA O SINAL 'C' PARA ESCRITA, '01' SELECIONA RA E '10' RB. 
WITH ESCRITA_C_BUS  SELECT
	MUX_3 <= C_Address(3 DOWNTO 0) WHEN "00",
	Bank_Register(3)(7 DOWNTO 4) WHEN "01",--RA
	Bank_Register(3)(3 DOWNTO 0) WHEN "10",--RB
	C_Address(3 DOWNTO 0) WHEN OTHERS;

A_Output(15 DOWNTO 0) <= Bank_Register(conv_integer(MUX_1))(15 DOWNTO 0);

B_Output(15 DOWNTO 0) <= Bank_Register(conv_integer(MUX_2))(15 DOWNTO 0);


Write_Bank_Registe_Process : PROCESS (CLK, ENC, RESET)
	BEGIN
		IF RESET = '1' THEN
			Bank_Register(0) <= "0000000000000000"; -- PC Register
			Bank_Register(1) <= "0000000000000000"; -- AC Register
			Bank_Register(2) <= "0000000000000000"; -- SP Register
			Bank_Register(3) <= "0000000000000000"; -- IR Regisetr
			Bank_Register(4) <= "0000000000000000"; -- TIR Register
			Bank_Register(5) <= "0000000000000000"; -- Constant ZERO Register
			Bank_Register(6) <= "0000000000000001"; -- Constant +1 Register
			Bank_Register(7) <= "1111111111111111"; -- Constant -1 Register
			Bank_Register(8) <= "0000111111111111"; -- AMASK Register
			Bank_Register(9) <= "0000000011111111"; -- SMASK Register
			Bank_Register(10) <= "0000000000000000"; -- A Register
			Bank_Register(11) <= "0000000000000000"; -- B Register
			Bank_Register(12) <= "0000000000000000"; -- C Register
			Bank_Register(13) <= "0000000000000000"; -- D Register
			Bank_Register(14) <= "0000000000000000"; -- E Register
			Bank_Register(15) <= "0000000000000000"; -- F Register

		ELSIF ((CLK'event AND CLK = '1') AND (ENC = '1')) THEN
				IF (C_Address(3 downto 0) = "0101") THEN
					Bank_Register(5) <= "0000000000000000";
				ELSIF (C_Address(3 downto 0) = "0110") THEN
					Bank_Register(6) <= "0000000000000001";
				ELSIF (C_Address(3 downto 0) = "0111") THEN
					Bank_Register(7) <= "1111111111111111";
				ELSIF (C_Address(3 downto 0) = "1000") THEN
					Bank_Register(8) <= "0000111111111111";
				ELSIF (C_Address(3 downto 0) = "1001") THEN
					Bank_Register(9) <= "0000000011111111";
				ELSE
													
					Bank_Register(conv_integer(MUX_3)) <= C_Input(15 DOWNTO 0);

				END IF;
		END IF;
	END PROCESS Write_Bank_Registe_Process;

END Behavioral;