-- A + B      (código "0000"- Sendo A a saída do amux)
-- A AND B  (código "0001"- Sendo A a saída do amux)
-- A            (código "0010"- Sendo A a saída do amux) 
-- NOT A     (código "0011"- Sendo A a saída do amux)
-- A OR B    (código "0100"- Sendo A a saída do amux)
-- SLT         (código "0101"- Sendo A a saída do amux)  -- (SE A < B ULA_saida = 1; senão ULA_saida = 0;)
-- A XOR B  (código "0111"- Sendo A a saída do amux)
-- SLL XX    (código "10XX"- Sendo A a saída do amux) -- Desloca XX bits de A a esquerda
-- SRL XX   (código "11XX"- Sendo A a saída do amux) -- Desloca XX bits de A a direita

 

-- Código MIC_amux_alu_2 --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

 

ENTITY MIC_amux_alu_2 IS

PORT (
	AMUX : IN std_logic;
	ALU_SH : IN std_logic_vector(3 DOWNTO 0); -- Criamos uma porta para substituir o ALU e o SH, essa porta tem 4 bits e serve para especificar qual será a operação feita.
	A_Input : IN std_logic_vector(15 DOWNTO 0);
	B_Input : IN std_logic_vector(15 DOWNTO 0);
	MBR_Input : IN std_logic_vector(15 DOWNTO 0);
	clk : IN std_logic;-- usado no processo SLT.
	
	N : OUT std_logic;
	Z : OUT std_logic;
	ALU_SH_Output : INOUT std_logic_vector(15 DOWNTO 0)); -- Ao invés de ter a saíada SH_output, agora temos a ALU_SH_OUTPUT, já que juntamos a ula e o sh.

END MIC_amux_alu_2;


Architecture behavioral OF MIC_amux_alu_2 IS

SIGNAL Input_A : std_logic_vector(15 DOWNTO 0);
SIGNAL IF_A_B: std_logic_vector(15 DOWNTO 0); -- Sinal para realizar a operação condicional entre input_A e B_input para a instrução SLT. 

-- O sinal ALU_Output foi apagado pois a saíada da ula_sh já vai direto para a interface, no barramento C. 
BEGIN

SLT_process : PROCESS(clk)
BEGIN
	IF ( rising_edge(clk)) THEN
		IF(input_A < B_input) THEN
			IF_A_B <= "0000000000000001";
		ELSE  
			IF_A_B <= "0000000000000000";
			END IF;
	END IF;
END PROCESS SLT_process ;



WITH AMUX SELECT
	Input_A <= A_Input(15 DOWNTO 0) WHEN '0',
	MBR_Input(15 DOWNTO 0) WHEN OTHERS;

WITH ALU_SH_Output SELECT
	Z <= '1' WHEN "0000000000000000",
	'0' WHEN OTHERS;

N <= ALU_SH_Output (15);

WITH ALU_SH SELECT
ALU_SH_Output <= input_A( 15 DOWNTO 0) + B_input(15 DOWNTO 0) WHEN "0000",
	input_A( 15 DOWNTO 0) AND  B_input(15 DOWNTO 0) WHEN "0001",
	input_A( 15 DOWNTO 0)  WHEN "0010",
	NOT input_A(15 DOWNTO 0) WHEN "0011",
	input_A( 15 DOWNTO 0) OR  B_input(15 DOWNTO 0) WHEN "0100",
	IF_A_B WHEN "0101",
	input_A( 15 DOWNTO 0) -  B_input(15 DOWNTO 0) WHEN "0110",
	input_A( 15 DOWNTO 0) XOR  B_input(15 DOWNTO 0) WHEN "0111",
	ALU_SH_Output WHEN "1000",
	input_A( 14 DOWNTO 0) & '0' WHEN "1001",
	input_A( 13 DOWNTO 0) & "00" WHEN "1010",
	input_A( 12 DOWNTO 0) & "000" WHEN "1011",
	ALU_SH_Output WHEN "1100",
	'0' & input_A( 15 DOWNTO 1) WHEN "1101",
	"00" & input_A( 15 DOWNTO 2) WHEN "1110",
	"000" & input_A( 15 DOWNTO 3) WHEN "1111",
	ALU_SH_Output WHEN OTHERS;
	
END behavioral;
