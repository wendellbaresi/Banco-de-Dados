-- Mini Projetos --
CREATE DATABASE odonto;
USE odonto;


-- Criação de Tabelas --

CREATE TABLE Endereco (
	Id_Endereco INT PRIMARY KEY,
    Rua VARCHAR(45),
    Cidade VARCHAR(45),
    Bairro VARCHAR(45),
    UF VARCHAR(2),
    CEP VARCHAR(10)
);

CREATE TABLE Dentista (
	CRO VARCHAR(12) PRIMARY KEY,
    Nome VARCHAR(45),
    Especialidade VARCHAR(45),
    Email VARCHAR(45),
    Endereco_Id INT,
    FOREIGN KEY (Endereco_Id)
	REFERENCES Endereco (Id_Endereco)
);

CREATE TABLE Paciente (
	CPF VARCHAR(12) PRIMARY KEY,
    Nome VARCHAR(45),
    RG VARCHAR(45),
    Dt_Nasc VARCHAR(45),
    Sexo VARCHAR(10),
    Endereco_Id INT,
    FOREIGN KEY (Endereco_Id)
	REFERENCES Endereco (Id_Endereco)
);

CREATE TABLE Telefone (
	Id_Telefone INT AUTO_INCREMENT PRIMARY KEY,
    ddd VARCHAR(2),
    Telefone1 VARCHAR(11),
	Paciente_CPF VARCHAR(12),
    Dentista_CRO VARCHAR(12),
    FOREIGN KEY (Paciente_CPF)
	REFERENCES paciente (CPF),
    FOREIGN KEY (Dentista_CRO)
	REFERENCES dentista (CRO)
);

CREATE TABLE Consulta (
	Id_Consulta INT AUTO_INCREMENT PRIMARY KEY,
    Data_Consulta DATE,
    Hora VARCHAR(45),
    Tipo VARCHAR(45),
    Valor DECIMAL,
    Status VARCHAR(45),
    Dentista_CRO VARCHAR(12),
    Paciente_CPF VARCHAR(12),
    Endereco_Id INT,
    FOREIGN KEY (Dentista_CRO)
	REFERENCES Dentista (CRO),
    FOREIGN KEY (Paciente_CPF)
	REFERENCES Paciente (CPF),
    FOREIGN KEY (Endereco_Id)
	REFERENCES Endereco (Id_Endereco)
);



CREATE TABLE Procedimento (
	Idprocedimento INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    Descricao VARCHAR(45),
    Valor DECIMAL
);


CREATE TABLE Procedimento_Consulta (
	Consulta_Id INT AUTO_INCREMENT PRIMARY KEY,
    Procedimento_Id INT,
    valor DECIMAL,
    FOREIGN KEY (Procedimento_Id)
    REFERENCES Procedimento (Idprocedimento),
    FOREIGN KEY (Consulta_Id)
    REFERENCES Consulta (Id_Consulta)
);

-- Inserir Values Endereço - Dentista --
INSERT INTO endereco VALUES(1,'Quadra 803, Lote 415','Brasília','Recanto das Emas',
'DF','72650400');
INSERT INTO endereco VALUES(2,'Quadra 204 Conjunto 11, Lote 494','Brasília',
'São Sebastião','DF','73401203');
INSERT INTO endereco VALUES(3,'Jardim Botânico Chácara 5, Lote 367',
'Brasília','Setor Habitacional Jardim Botânico','DF','71680388');

SELECT * FROM endereco;

-- Inserir Values Dentista --

INSERT INTO dentista VALUES('DF 8658','Stefany Analu Elisa da Costa','Odontopediatria',
'stefanyanaludacosta@girocenter.com.br',1);
INSERT INTO dentista VALUES('DF 7854','Benjamin Heitor Sebastião Monteiro','Endodontia',
'benjamin-monteiro95@recnev.com.br',2);
INSERT INTO dentista VALUES('DF 4453','Kauê Pietro da Mata','Ortodontia',
'kaue_damata@compuativa.com.br',3);

SELECT * FROM dentista;

-- Inserir Values Telefone - Dentista --
INSERT INTO telefone VALUES(NULL,'61','99514-9768',NULL,'DF 8658');
INSERT INTO telefone VALUES(NULL,'61','99277-9515',NULL,'DF 7854');
INSERT INTO telefone VALUES(NULL,'61','98626-6766',NULL,'DF 4453');

SELECT * FROM telefone;

-- Inserir Values Endereço - Paciente --
INSERT INTO Endereco VALUES(4,'Quadra QR 1033 Conjunto 5','Brasília','Samambaia Norte','DF','72339-075');
INSERT INTO Endereco VALUES(5,'Rua 12 Chácara 129A Conjunto E, Lote 557','Brasília','Vicente Pires','DF','72007-770');
INSERT INTO Endereco VALUES(6,'Quadra 602 Conjunto 3-B, Casa 947','Brasília','Recanto das Emas','DF','72640-221');

SELECT * FROM endereco;

-- Inserir Values Paciente --
INSERT INTO Paciente VALUES('01146367104','Sueli Isadora Barros','285029988','1953-03-06','F',4);
INSERT INTO Paciente VALUES('99543612196','Gael Rodrigo Silveira','246295429','2001-02-24','M',5);
INSERT INTO Paciente VALUES('71829333143','Osvaldo Sebastião Paulo Melo','401863815','1973-03-01','M',6);

SELECT * FROM paciente;

-- Inserir Values Telefone - Paciente --
INSERT INTO Telefone VALUES(NULL,'61','98617-5364','01146367104',NULL);
INSERT INTO Telefone VALUES(NULL,'61','99736-0391','99543612196',NULL);
INSERT INTO Telefone VALUES(NULL,'61','99648-5731','71829333143',NULL);

SELECT * FROM telefone;


-- Criação de Procedure Dentista --
DELIMITER @@
CREATE PROCEDURE novo_dentista
	(CRO VARCHAR(12), Nome VARCHAR(45), Especialidade VARCHAR(45), Email VARCHAR(45))
	BEGIN
    DECLARE new_dentista INT;
		INSERT INTO Dentista VALUES (CRO, Nome, Especialidade, Email, new_dentista);
	END @@
    
DROP PROCEDURE novo_dentista;

-- Chamando(CALL) a Procedure --
CALL novo_dentista ('DF 8523','Elaine Stefany Elza Caldeira','Endodontia',
'elaine-caldeira94@eguia.com.br');


CALL novo_dentista('DF 7894','Tânia Emily da Cruz','Implantodontia',
'tania.emily.dacruz@gsw.com.br');

CALL novo_dentista('','Raimundo Davi Cauê Mendes','Periodontia',
'raimundo-mendes79@tribunaimpressa.com.br');

SELECT * FROM dentista;
    
-- Correção da Procedure --
    

DELIMITER @@
CREATE PROCEDURE novo_dentista
(CRO VARCHAR(12), Nome VARCHAR(45), Especialidade VARCHAR(45), Email VARCHAR(45),
Telefone VARCHAR(11),
Rua VARCHAR (45), Cidade VARCHAR(45), Bairro VARCHAR(45),
UF VARCHAR(2), CEP VARCHAR(10))
BEGIN
	DECLARE dentista_novo INT;
    INSERT INTO Endereco VALUES (NULL,Rua,Cidade,Bairro,UF,CEP);
    SELECT Id_Endereco INTO dentista_novo FROM Endereco ORDER BY Id_Endereco DESC LIMIT 1;
    INSERT INTO Dentista VALUES (CRO,Nome,Especialidade,Email,dentista_novo);
    INSERT INTO Telefone VALUES (NULL,61,Telefone,NULL,CRO);
END @@
    

-- Correção Professor --

DELIMITER //
CREATE PROCEDURE INSERIR_DENTISTA (CRO VARCHAR(10), NOME VARCHAR(45), 
ESPECIALIDADE VARCHAR(45),
EMAIL VARCHAR(45),TELEFONE VARCHAR(11), RUA VARCHAR(45),
CIDADE VARCHAR(20),BAIRRO VARCHAR(20),UF VARCHAR(2),CEP VARCHAR(10))
BEGIN
	DECLARE NOVA_ID INT;
	INSERT INTO ENDERECO VALUES (NULL,RUA,CIDADE,BAIRRO,UF,CEP);
    SELECT ID_ENDERECO INTO NOVA_ID FROM ENDERECO ORDER BY ID_ENDERECO DESC LIMIT 1;
    INSERT INTO DENTISTA VALUES (CRO,NOME,ESPECIALIDADE,EMAIL,NOVA_ID);
    INSERT INTO TELEFONE VALUES (NULL,61,TELEFONE,NULL,CRO);
END //

-- Chamando(CALL) a Procedure Criada --

CALL INSERIR_DENTISTA('DF 2235','Carlos Vinicius Ferreira',
'Periodontia','carlosviniciusferreira_@gmail.com','983482737',
'Quadra SCN Quadra 3 Bloco A','Brasília','Asa Norte','DF','70713010');

CALL novo_dentista ('DF 8523','Elaine Stefany Elza Caldeira','Endodontia','elaine-caldeira94@eguia.com.br',
'99274-0235','Setor SCIA Quadra 8 Conjunto 13','Brasília','Guará','DF','71250-735');
CALL novo_dentista('DF 7894','Tânia Emily da Cruz','Implantodontia','tania.emily.dacruz@gsw.com.br','98585-6091',
'Quadra 6 Conjunto G, Casa 606','Brasília','Gama','DF','72415-307');
CALL novo_dentista('','Raimundo Davi Cauê Mendes','Periodontia','raimundo-mendes79@tribunaimpressa.com.br',
'98370-7452','Quadra QE 9 Conjunto F, Casa 714','Brasília','Guará I','71020-069');



-- Inserir Paciente --

DELIMITER @@
CREATE PROCEDURE novo_paciente 
	(CPF VARCHAR(12), Nome VARCHAR(45), RG VARCHAR(45), 
    Dt_Nasc VARCHAR(45), Sexo VARCHAR(10))
	BEGIN
		DECLARE paciente_odonto VARCHAR(40);
		INSERT INTO Paciente VALUES (CPF,Nome,RG,Dt_Nasc,Sexo,paciente_odonto);
        
	END @@
    
    
-- Chamando(CALL) a Procedure --
CALL novo_paciente('60719747120','Manuela Tânia Moura','312816789','1949-02-08','F');
CALL novo_paciente('97819359102','Bruno Filipe André Novaes','481330914','1954-02-18','M');
CALL novo_paciente('17723360177','Brenda Luna Assis','478120977','1974-02-02','F');
 
SELECT * FROM paciente;

-- Correção Professor --

DELIMITER //
CREATE PROCEDURE INSERIR_PACIENTE (CPF VARCHAR(11),NOME VARCHAR(45),RG VARCHAR(20),DT_NASC DATE,
SEXO VARCHAR(2),TELEFONE VARCHAR(11), RUA VARCHAR(45),CIDADE VARCHAR(20),BAIRRO VARCHAR(20),UF VARCHAR(2),CEP VARCHAR(10))
BEGIN
	DECLARE NOVA_ID INT;
	INSERT INTO ENDERECO VALUES (NULL,RUA,CIDADE,BAIRRO,UF,CEP);
    SELECT ID_ENDERECO INTO NOVA_ID FROM ENDERECO ORDER BY ID_ENDERECO DESC LIMIT 1;
    INSERT INTO PACIENTE VALUES (CPF,NOME,RG,DT_NASC,SEXO,NOVA_ID);
    INSERT INTO TELEFONE VALUES (NULL,61,TELEFONE,CPF,NULL);
END //

CALL novo_paciente('01146367104','Sueli Isadora Barros','285029988','1953-03-06','F');
CALL novo_paciente('99543612196','Gael Rodrigo Silveira','246295429','2001-02-24','M');
CALL novo_paciente('71829333143','Osvaldo Sebastião Paulo Melo','401863815','1973-03-01','M');

-- Procedure do Professor Diferente --
DELIMITER //
CREATE PROCEDURE cad_paciente 
(nome VARCHAR(11),cpf VARCHAR(45),rg VARCHAR(20),nascimento DATE,
sexo VARCHAR(2), rua VARCHAR(45),cidade VARCHAR(20),bairro VARCHAR(20),
uf VARCHAR(2),cep VARCHAR(10), ddd VARCHAR(3), tel VARCHAR(11))
BEGIN
	DECLARE vIdEnd INT;
	INSERT INTO endereco(rua,cidade,bairro,uf,cep) VALUES (rua,cidade,bairro,uf,cep);
    SELECT MAX(id) INTO vIdEnd FROM endereco;
    INSERT INTO paciente(cpf,nome,rg,dt_nasc,sexo_id_end) VALUES (cpf,nome,rg,dt_nasc,sexo,vIdEnd);
    INSERT INTO telefone(ddd,tel,paciente_cpf) VALUES (ddd,tel,cpf);
    SELECT "Cadastro realizado com sucesso!" AS Mensagem;
END //

CALL cad_paciente('Vitor Yuri Gomes','28820584115','132145169','1968-04-14','M',
'Quadra QC 02 Conjunto B Bloco 2','Valparaíso de Goiás','Cidade Jardins','GO',
'72878262','61','991594037');

-- Criação da Procedure de Procedimento --

DELIMITER @@
CREATE PROCEDURE procedimentos_novos 
	(Idprocedimento INT, Nome VARCHAR(45), Descricao VARCHAR(100), Valor FLOAT)
	BEGIN
		DECLARE novo_atendimento INT;
		INSERT INTO Procedimento VALUES (Idprocedimento, Nome, Descricao,Valor,novo_atendimento);
	END @@
    
DROP PROCEDURE procedimentos_novos;

CALL procedimentos_novos(1,'Odontopediatria','Tratamento das doenças dos dentes.','150.00');
CALL procedimentos_novos(NULL,'Endodontia','Remoção da polpa do dente.','200.00');
CALL procedimentos_novos('Periodontia','Tratar doenças que atingem a gengiva','250.00');

-- Corregindo observando a do professor --

DELIMITER @@
CREATE PROCEDURE procedimentos_novos 
	(Nome VARCHAR(45), Descricao VARCHAR(100), Valor FLOAT)
	BEGIN
		INSERT INTO Procedimento VALUES (NULL,Nome,Descricao,Valor);
	END @@
    
CALL procedimentos_novos('Odontopediatria','Tratamento das doenças dos dentes.','150.00');
CALL procedimentos_novos('Endodontia','Remoção da polpa do dente.','200.00');
CALL procedimentos_novos('Periodontia','Tratar doenças que atingem a gengiva','250.00');

SELECT * FROM procedimento;

-- Correção do Professor --

DELIMITER //
CREATE PROCEDURE INSERIR_PROCEDIMENTO (NOME VARCHAR(45),DESCRICAO VARCHAR(100),VALOR FLOAT)
BEGIN
	INSERT INTO procedimento VALUES (NULL,NOME,DESCRICAO,VALOR);
END //

DROP PROCEDURE inserir_procedimento;

CALL INSERIR_PROCEDIMENTO('Periodontia','Estudo e tratamento das doenças do sistema de implantação e suporte dos dentes.',200.00);
CALL INSERIR_PROCEDIMENTO('Ortodontia','Corrige a posição dos dentes e dos ossos maxilares posicionados de forma inadequada.',250.00);
CALL INSERIR_PROCEDIMENTO('Implantodontia','Restabelecer a função de mastigação e estética perdidas.',300.00);

-- Criação da Procedure de marcar consulta --

DELIMITER //
CREATE PROCEDURE MARCAR_CONSULTA (CPF_1 VARCHAR(11),DATA DATE,HORA_1 VARCHAR(10),TIPO VARCHAR(45),CRO_1 VARCHAR(10))
BEGIN
	DECLARE STATUS VARCHAR(45);
    DECLARE HORA_2 VARCHAR(10);
    DECLARE VALOR_CONSULTA FLOAT;
    DECLARE END_ID INT;
    DECLARE ESPECIALISTA VARCHAR(45);
    DECLARE EXIT HANDLER FOR 1452 SELECT 'CRO INEXISTNETE: ' AS MENSAGEM;
    SELECT HORA INTO HORA_2 FROM CONSULTA WHERE DATA_CONSULTA = DATA AND HORA = HORA_1;
    SELECT VALOR INTO VALOR_CONSULTA FROM PROCEDIMENTO WHERE NOME = TIPO;
    SELECT ENDERECO_ID INTO END_ID FROM PACIENTE WHERE CPF = CPF_1;
    SELECT ESPECIALIDADE INTO ESPECIALISTA FROM DENTISTA WHERE CRO = CRO_1;
    IF HORA_2 = HORA_1 THEN
		SELECT 'ESCOLHA UM NOVO HORÁRIO PARA O DIA: ' AS MENSAGEM, DATA;
	ELSEIF TIPO <> ESPECIALISTA THEN
		SELECT 'O DENTISTA ESCOLHIDO É DA ESPECIALIDADE: ' AS MENSAGEM, ESPECIALISTA;
    ELSE
		SET STATUS = 'MARCADO';
		INSERT INTO CONSULTA VALUES (NULL,DATA,HORA_1,TIPO,VALOR_CONSULTA,STATUS,CRO_1,CPF_1,END_ID);
        SELECT 'CONSULTA MARCADA COM SUCESSO' AS MENSAGEM, DATA, HORA_1;
	END IF;    
END//

DROP PROCEDURE marcar_consulta;

CALL MARCAR_CONSULTA('01146367104','2021-04-30','12:00','Odontopediatria','DF 8658');
CALL MARCAR_CONSULTA('01146367104','2021-05-01','15:00','Odontopediatria','DF 8658');
CALL MARCAR_CONSULTA('71142082199','2021-05-01','12:00','Implantodontia','DF 7894');
CALL MARCAR_CONSULTA('71142082199','2021-05-01','10:30','Implantodontia','DF 7894');
CALL MARCAR_CONSULTA('60719747120','2021-03-14','12:00','Endodontia','DF 8523');
CALL MARCAR_CONSULTA('60719747120','2021-07-07','09:00','Endodontia','DF 8523');


SELECT * FROM paciente;
SELECT * FROM Procedimento_consulta;
SELECT * FROM dentista;

-- Criando a Procedure Nota --

DELIMITER @@
CREATE PROCEDURE cria_nota (procedimento_1 VARCHAR(45))
	BEGIN
		DECLARE consulta_id INT;
		DECLARE procedimento_id INT;
		DECLARE valor_1 FLOAT;
		SELECT MAX(id_consulta) INTO consulta_id FROM consulta;
		SELECT id_procedimento INTO procedimento_id FROM Procedimento WHERE nome = procedimento_1;
		SELECT valor INTO valor_1 FROM Procedimento WHERE nome = procedimento_1;
		INSERT INTO procedimento_consulta VALUES (NULL, consulta_id, procedimento_id, valor_1);
    END @@
    
  -- Criando tabela Fidelidade --

CREATE TABLE FIDELIDADE(
ID INT AUTO_INCREMENT PRIMARY KEY,
CPF VARCHAR(11),
PONTOS INT);

ALTER TABLE FIDELIDADE ADD CONSTRAINT
FOREIGN KEY (CPF) REFERENCES PACIENTE (CPF);

DELETE FROM consulta;
DELETE FROM fidelidade;  

    
-- Criação Procedure que Ganha pontos quando a Consulta e marcada --

DELIMITER //
CREATE PROCEDURE MARCAR_CONSULTA (CPF_1 VARCHAR(11),DATA DATE,HORA_1 VARCHAR(10),TIPO VARCHAR(45),CRO_1 VARCHAR(10))
BEGIN
	DECLARE STATUS VARCHAR(45);
    DECLARE HORA_2 VARCHAR(10);
    DECLARE VALOR_CONSULTA FLOAT;
    DECLARE END_ID INT;
    DECLARE pontos_1 INT DEFAULT 0;
    DECLARE ESPECIALISTA VARCHAR(45);
    DECLARE EXIT HANDLER FOR 1452 SELECT 'CRO INEXISTNETE: ' AS MENSAGEM;
    SELECT HORA INTO HORA_2 FROM CONSULTA WHERE DATA_CONSULTA = DATA AND HORA = HORA_1;
    SELECT VALOR INTO VALOR_CONSULTA FROM PROCEDIMENTO WHERE NOME = TIPO;
    SELECT ENDERECO_ID INTO END_ID FROM PACIENTE WHERE CPF = CPF_1;
    SELECT ESPECIALIDADE INTO ESPECIALISTA FROM DENTISTA WHERE CRO = CRO_1;
    SELECT pontos INTO pontos_1 FROM fidelidade WHERE cpf = cpf_1;
    IF HORA_2 = HORA_1 THEN
		SELECT 'ESCOLHA UM NOVO HORÁRIO PARA O DIA: ' AS MENSAGEM, DATA;
	ELSEIF TIPO <> ESPECIALISTA THEN
		SELECT 'O DENTISTA ESCOLHIDO É DA ESPECIALIDADE: ' AS MENSAGEM, ESPECIALISTA;
    ELSE
		SET STATUS = 'MARCADO';
		INSERT INTO CONSULTA VALUES (NULL,DATA,HORA_1,TIPO,VALOR_CONSULTA,STATUS,CRO_1,CPF_1,END_ID);
        SET pontos_1 = pontos_1 + FLOOR(valor_consulta);
        CALL verifica_pontos(cpf_1, pontos_1);
        SELECT 'CONSULTA MARCADA COM SUCESSO' AS MENSAGEM, DATA, HORA_1;
	END IF;    
END//

DROP PROCEDURE MARCAR_CONSULTA;

DELIMITER @@
CREATE PROCEDURE verifica_pontos (cpf_1 VARCHAR(11), pontos_1 INT)
BEGIN 
		DECLARE cpf_2 VARCHAR(11);
		DECLARE pontos_2 INT;
		SELECT cpf INTO cpf_2 FROM fidelidade WHERE cpf = cpf_1;
	IF cpf_1 = cpf_2 THEN
		SELECT pontos INTO pontos_2 FROM fidelidade WHERE cpf = cpf_1;
		UPDATE fidelidade SET pontos = (pontos_2 + pontos_1) WHERE cpf = cpf_1;
	ELSE
		INSERT INTO fidelidade VALUES (NULL,cpf_1,pontos_1);
	END IF;
END @@



DROP PROCEDURE verifica_pontos;

-- Criando a Função --

DELIMITER @@
CREATE FUNCTION pontos()
RETURNS 
	BEGIN
		DECLARE ;
        SELECT ;
        RETURN retorno;		
    END @@

-- Correção do Professor --

SELECT nome, consulta_pontos(cpf) AS pontos FROM paciente;

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER @@
CREATE FUNCTION consulta_pontos(cpf2 VARCHAR(11))
RETURNS INT
	BEGIN
		DECLARE retorno INT;
        SELECT pontos INTO retorno FROM fidelidade WHERE cpf = cpf2;
        RETURN retorno;		
    END @@




