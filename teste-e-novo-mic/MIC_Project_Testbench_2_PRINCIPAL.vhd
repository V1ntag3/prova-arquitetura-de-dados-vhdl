LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
--Testbench--
ENTITY MIC_Project_Testbench_2_PRINCIPAL IS
	PORT(
	OUTPUT : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END MIC_Project_Testbench_2_PRINCIPAL;
--------------------------------
ARCHITECTURE Type_01 OF MIC_Project_Testbench_2_PRINCIPAL IS

CONSTANT Clk_period : time := 40 ns;
SIGNAL Clk_count : integer := 0;

SIGNAL CLK_Signal, RESET_Signal, AMUX_Signal, MBR_Signal, MAR_Signal : STD_LOGIC;
SIGNAL RD_Signal, WR_Signal, ENC_Signal : STD_LOGIC;
SIGNAL A_Signal, B_Signal, C_Signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL MEM_TO_MBR_Sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL MAR_OUTPUT_Sig : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL RD_OUTPUT_Sig, WR_OUTPUT_Sig, Z_Signal, N_Signal : STD_LOGIC;

SIGNAL DATA_OK_Signal : STD_LOGIC := '0';
SIGNAL ALU_SH_Signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL A_BUS_LEITURA_SIGNAL, B_BUS_LEITURA_SIGNAL, C_BUS_ESCRITA_SIGNAL : STD_LOGIC_VECTOR(1 DOWNTO 0);

COMPONENT MIC_Project_2 IS
	PORT (
		 RESET : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
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
		 A_BUS_LEITURA : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		 B_BUS_LEITURA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 C_BUS_ESCRITA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA_OK : IN STD_LOGIC;
		
		MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		RD_OUTPUT : OUT STD_LOGIC;
		WR_OUTPUT : OUT STD_LOGIC;
		Z         : OUT STD_LOGIC;
		N         : OUT STD_LOGIC);
END COMPONENT;
--------------------------------
BEGIN
MIC : MIC_Project_2
	PORT MAP (
		CLK => CLK_Signal, RESET => RESET_Signal, AMUX => AMUX_Signal,
		MBR => MBR_Signal, MAR => MAR_Signal, RD => RD_Signal, WR => WR_Signal,
		ENC => ENC_Signal, DATA_OK => DATA_OK_Signal, A => A_Signal, B => B_Signal,
		C => C_Signal, MBR_TO_MEM => OUTPUT,
		MEM_TO_MBR => MEM_TO_MBR_Sig, MAR_OUTPUT => MAR_OUTPUT_Sig,
		RD_OUTPUT => RD_OUTPUT_Sig, WR_OUTPUT => WR_OUTPUT_Sig, Z => Z_Signal,
		N => N_Signal, ALU_SH => ALU_SH_Signal,
		A_BUS_LEITURA => A_BUS_LEITURA_SIGNAL,
		B_BUS_LEITURA => B_BUS_LEITURA_SIGNAL,
		C_BUS_ESCRITA => C_BUS_ESCRITA_SIGNAL 
		);
--------------------------------		


Clock_Process : PROCESS 
  Begin
    CLK_Signal <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    CLK_Signal  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.


IF (Clk_count = 30) THEN     
REPORT "Stopping simulkation after 34 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

--------------------------------	

Reset_Process : PROCESS 
  Begin
    RESET_Signal <= '0';
    Wait for 10 ns;
    RESET_Signal <= '1';
    Wait for 30 ns;
    RESET_Signal <= '0';
    wait;

End Process Reset_Process;

--------------------------------	

PROCESS
	BEGIN
	--Instrução: Move Ra Rb. 
	--SIGNIFICADO: Ra := (Rb) 
	
	--ABNER
	-- SEGUNDO CICLO: Recebe a instrução 1111 0011 1010(RA) 1011(RB) da memoria e guarda no MBR.
		wait for 40ns;
		 AMUX_Signal  <= '0'; --0 OU 1?
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "1111001110101011";
		 DATA_OK_Signal <= '1';
		 
		-- TERCEIRO CICLO: Escreve o conteudo de MBR no reg IR (numero 3).
		wait for 40ns;
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0011";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
	-- QUARTO CICLO: Recebe o valor 1 da memoria e guarda no MBR.
		wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000001";
		 DATA_OK_Signal <= '1';
		 
		
		--QUINTO CICLO: Escreve o conteudo de MBR no reg RB (numero 11).
		 wait for 40ns;
		 
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "10";--CONTROLA O MULTIPLEXADOR. OU SEJA, SELECIONA O ENDEREÇO DE RB PARA ESCREVER O VALOR 1.
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --SEXTO CICLO: Escreve o conteudo de RB no RA (E EM MBR PARA SER VERIFICADO NA SAISA OUTPUT DO TESTE) DE ACORDO COM A INSTRUCAO JRLR. SIGNIFICADO: Ra := (Rb) 
		 wait for 40ns;
		 
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0010";
		 MBR_Signal   <= '1';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "10";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "01";--CONTROLA O MULTIPLEXADOR. OU SEJA, SELECIONA O ENDEREÇO DE RA PARA ESCREVER O CONTEUDO DE RB.
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --MANEL/FILIPE/MARCOS
		 --Jrlr Ra, Rb//Rb := PC; PC := Ra
		 --1111 0001 1010 (RA) 1011(RB)
		 --SÉTIMO CICLO: 1111000110101011 -> MBR
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "1111000110101011";
		 DATA_OK_Signal <= '1';
		 
		 --OITAVO CICLO: MBR -> IR
		 wait for 40ns;
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";--Transparência
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0011";--IR
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --NONO CICLO: 0000000000000100 -> MBR
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000100";
		 DATA_OK_Signal <= '1';
		 
		 --DECIMO CICLO: MBR(0000000000000100) -> PC 
		 wait for 40ns;
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";--Transparência
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0000";--PC
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --DECIMO PRIMEIRO CICLO: PC(0000000000000100) -> RB
		 wait for 40ns;
		 AMUX_Signal  <= '0';--A
		 ALU_SH_Signal   <= "0010";--Transparência
		 MBR_Signal   <= '1';--Saída
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";--PC
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "10";--RB
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --DECIMO SEGUNDO CICLO: RA(0000000000000001) -> PC
		 wait for 40ns;
		 AMUX_Signal  <= '0';--A
		 ALU_SH_Signal   <= "0010";--Transparência
		 MBR_Signal   <= '1';--Saída
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "01";--RA
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --EMANUEL
		 --Biz Ra, Rb // PC := (Ra) If Rb == 0 else PC := PC+1
		 --1111 0101 1010(RA) 1011(RB)
		 --DECIMO TERCEIRO CICLO: MEM(1111010110101011) -> MBR
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "1111010110101011";
		 DATA_OK_Signal <= '1';
		 
		 --DECIMO QUARTO CICLO: MBR(1111010110101011) -> IR
		 wait for 40ns;
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";--Transparência
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0011";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --DECIMO QUINTO CICLO: RB -> OUTPUT
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0010";--Transparência
		 MBR_Signal   <= '1';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "10";--RB
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --DECIMO SEXTO CICLO
		 wait for 40ns;
		 --O ELSE será acessado nesse caso.
		 IF(OUTPUT = "0000000000000000") THEN --RA(0000000000000001) -> PC
			AMUX_Signal  <= '0';
			ALU_SH_Signal   <= "0010";--Transparência
			MBR_Signal   <= '1';
			MAR_Signal   <= '0';
			RD_Signal    <= '0';
			WR_Signal    <= '0';
			ENC_Signal   <= '1';
			C_Signal     <= "0000";
			B_Signal    <= "0000";
			A_Signal    <= "0000";
			A_BUS_LEITURA_SIGNAL <= "01";--RA
			B_BUS_LEITURA_SIGNAL <= "00";
			C_BUS_ESCRITA_SIGNAL <= "00";
			MEM_TO_MBR_Sig <= "0000000000000000";
			DATA_OK_Signal <= '0';
		ELSE --PC + 1 -> PC
			AMUX_Signal  <= '0';
			ALU_SH_Signal   <= "0000";--Soma A+B
			MBR_Signal   <= '1';
			MAR_Signal   <= '0';
			RD_Signal    <= '0';
			WR_Signal    <= '0';
			ENC_Signal   <= '1';
			C_Signal     <= "0000";--PC
			B_Signal    <= "0110";--1
			A_Signal    <= "0000";--PC
			A_BUS_LEITURA_SIGNAL <= "00";
			B_BUS_LEITURA_SIGNAL <= "00";
			C_BUS_ESCRITA_SIGNAL <= "00";
			MEM_TO_MBR_Sig <= "0000000000000000";
			DATA_OK_Signal <= '0';
		
		END IF;
		 
		 --FILIPE
		 --AC := Ra AND Rb Or Ra
		 --DECIMO SETIMO CICLO
		 wait for 40ns;
		AMUX_Signal  <= '0'; 
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "1111011110101011";
		 DATA_OK_Signal <= '1';
		 
		 -- DECIMO OITAVO CICLO: Escreve o conteudo de MBR no reg IR (numero 3).
		wait for 40ns;
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0011";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --DECIMO NONO CICLO: ESCREVE O RESULTADO DE  RA AND RB NO REGISTRADOR C
		 
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0001";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "1100";-- C
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "01";--RA
		 B_BUS_LEITURA_SIGNAL <= "10";--RB
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --VIGESIMO CICLO: ESCREVE O RESULTADO DE  C OR RA NO REGISTRADOR AC
		 
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0100";
		 MBR_Signal   <= '1';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0001";--AC
		 B_Signal    <= "1100";--C
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "01";--RA
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --MARCOS
		 --VIGESIMO PRIMEIRO: Começo da instrução.
		 --AC := Ra AND NOT(Rb) 
		 --1111 1001  1010(RA) 1011(RB)
		 -- coloca em MBR a instrução.
		 wait for 40ns;
		 
		AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0000";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '0';
		 C_Signal     <= "0000";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "1111100110101011";
		 DATA_OK_Signal <= '1';
		 
		 --VIGESIMO SEGUNDO CICLO: Escreve o conteudo de MBR no reg IR (numero 3).
		wait for 40ns;
		 AMUX_Signal  <= '1';
		 ALU_SH_Signal   <= "0010";
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0011";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "00";
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --VIGESIMO TERCEIRO CICLO: ESCREVE O RESULTADO DE  NOT(RB) NO REGISTRADOR C
		 
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0011";--NOT
		 MBR_Signal   <= '0';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "1100";
		 B_Signal    <= "0000";
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "10";--RB
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 --VIGESIMO QUARTO CICLO: ESCREVE O RESULTADO DE  C AND RA NO REGISTRADOR AC
		 
		 wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_SH_Signal   <= "0001";
		 MBR_Signal   <= '1';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0001";--AC
		 B_Signal    <= "1100";--C
		 A_Signal    <= "0000";
		 A_BUS_LEITURA_SIGNAL <= "01";--RA
		 B_BUS_LEITURA_SIGNAL <= "00";
		 C_BUS_ESCRITA_SIGNAL <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		 
		 wait;
		 		
END process;


END Type_01;