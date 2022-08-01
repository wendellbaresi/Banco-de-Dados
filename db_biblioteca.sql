CREATE DATABASE db_biblioteca
ON PRIMARY (
NAME = db_biblioteca,
FILENAME = 'D:\Estudos\Aperfeiçoamento em SQL Server\SQLServer\db_biblioteca.MDF',
SIZE = 8MB,
MAXSIZE = 20MB,
FILEGROWTH = 15%
)
GO

USE db_biblioteca
GO

CREATE TABLE autor(
	ID_autor INTEGER PRIMARY KEY NOT NULL,
	nome VARCHAR(50) NOT NULL,
	sobrenome VARCHAR(50) NOT NULL
)
GO

sp_help autor
GO

CREATE TABLE editora(
	ID_editora INTEGER PRIMARY KEY NOT NULL,
	nome VARCHAR(50) NOT NULL
)
GO


sp_help editora
GO

CREATE TABLE livro (
	ID_livro INTEGER PRIMARY KEY (ID_livro) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	ISBN VARCHAR(30) UNIQUE NOT NULL,
	dt_publicacao DATE NOT NULL,
	preco_livro MONEY NOT NULL,
	Autor INTEGER NOT NULL,
	CONSTRAINT fk_Autor FOREIGN KEY (Autor) 
	REFERENCES autor(ID_autor)
)
GO


USE db_biblioteca
GO

-- DROPANDO A PRIMARY KEY DA TABELA AUTOR

ALTER TABLE autor
DROP CONSTRAINT PK__autor__E2671E1B25776F1D
GO

-- DROPANDO A LIGAÇÃO ENTRE AS CONSTRAINTS

ALTER TABLE livro
DROP CONSTRAINT fk_ID_autor
GO

-- DROPANDO A COLUNA DA TABELA AUTOR

ALTER TABLE autor
DROP COLUMN ID_autor
GO

-- CRIANDO A NOVA COLUNA COM A CHAVE PRIMARIA DA TABELA AUTOR

ALTER TABLE autor
ADD ID_autor INT IDENTITY(1,1)
CONSTRAINT pk_ID_autor PRIMARY KEY (ID_autor)
GO

-- DROPANDO A COLUNA DA TABELA LIVRO
ALTER TABLE livro
DROP COLUMN ID_autor
GO

-- ALTERANDO A TABELA 

ALTER TABLE livro
ADD ID_autor INT
CONSTRAINT fk_ID_autor FOREIGN KEY (ID_autor) REFERENCES autor(ID_autor) ON DELETE CASCADE
GO

-- DROPANDO A PRIMARY KEY DA TABELA LIVRO

ALTER TABLE livro
DROP CONSTRAINT PK__livro__726BCFAE999F47ED
GO

-- DROPANDO A COLUNA DA TABELA LIVRO

ALTER TABLE livro
DROP COLUMN ID_livro
GO

-- CRIANDO NOVA COLUNA DA TABELA LIVRO

ALTER TABLE livro
ADD ID_livro INT IDENTITY(1,1)
CONSTRAINT pk_ID_livro PRIMARY KEY (ID_livro)
GO


-- DROPANDO A CONSTRAINT UNIQUE DA TABELA LIVRO

ALTER TABLE livro
DROP CONSTRAINT UQ__livro__447D36EAB09F102E
GO

-- DROPANDO A COLUNA QUE PERDEU A UNIQUE
ALTER TABLE livro
ADD ISBN VARCHAR(30)
GO

-- CRIANDO COLUNA COM A CHAVE UNIQUE
ALTER TABLE livro
ADD CONSTRAINT uq_ISBN UNIQUE (ISBN)
GO

-- INSERINDO DADOS

ALTER TABLE livro
ALTER COLUMN ID_autor INT NULL
GO

SELECT * FROM livro
GO

/* INSERTS NA TABELA LIVRO */
INSERT INTO livro (nome, ISBN, dt_publicacao, preco_livro, ID_editora, ID_Autor)
VALUES
('O maravilhoso mágico de Oz','9788516084936','8.10.2014','80.5','15','1'),
('O Gato Malhado e a Andorinha Sinhá','9788574063423','10.7.2002','35.80','16','2'),
('Mau Começo','9788535900941','15.6.2014','93.75','17','3'),
('O Pequeno Príncipe','9788596004329','17.4.2012','50.69','18','4'),
('O Anjo Linguarudo','856023168','17.4.2012','100.15','19','5'),
('Confissões de um Vira-Lata','9788526016866','30.8.2016','50.69','20','6'),
('Vendedor de Sustos','9788532292827','01.01.2010','99.99','21','7')
GO

SELECT * FROM livro
GO

/* INSERTS SEM EDITORA */

INSERT INTO autor (nome,sobrenome) VALUES
('J.K.', 'Rowling'),
('George R.R.' ,'Martin'),
('J.R.R.', 'Tolkien')
GO

INSERT INTO livro (nome, ISBN, dt_publicacao, preco_livro,ID_editora, ID_Autor)
VALUES
('Harry Potter e a pedra filosofal','9788532530783','19.8.2017','22.9',NULL,'8'),
('A Guerra dos Tronos : As Crônicas de Gelo e Fogo','9788556510785','25.3.2019','66.99',NULL,'9'),
('O Senhor dos Anéis: A Sociedade do Anel','9788595084759','25.11.2019','42.99',NULL,'10')
GO



INSERT INTO livro (nome, dt_publicacao, preco_livro,ISBN)
VALUES
('O Hobbit','15.6.2019','27.79','9788595084742'),
('O Pequeno Príncipe','27.8.2018','16.86','9788595081512'),
('Superman','8.12.2015','61.92','9788583781943')
GO

SELECT * FROM livro
GO



INSERT INTO autor (nome, sobrenome, ID_autor)
VALUES
('Stanley', 'Lee', '1'),
('Frank','Miller','2')
GO

SELECT * FROM autor
GO

INSERT INTO editora (ID_editora,nome)
VALUES
('1','DC COMICS'),
('2','Marvel')
GO

SELECT * FROM editora
GO

-- FAZENDO SELECT QUE FAZ A COPIA

SELECT * FROM autor
GO

SELECT * INTO autor_copia FROM autor
GO

SELECT * FROM autor
SELECT * FROM autor_copia
GO

-- COPIA DAS TABELAS 

SELECT * INTO editoras_back FROM editora
GO

SELECT * INTO livro_copia FROM livro
GO


SELECT * FROM Autor
SELECT * FROM autor_copia
GO

-- UPDATE DE INSERTS

UPDATE livro
SET preco_livro = '76.69'
WHERE ID_livro IN ('8','6')
GO

UPDATE autor_copia 
SET nome = 'Frank Miller'
WHERE ID_autor = '1'
GO

DELETE FROM autor_copia
WHERE ID_Autor = '1'
GO


// /* SUB SELECTS */
SELECT nome, preco_livro FROM livro
GO

// /* UTILIZANDO O MAX */

SELECT MAX(preco_livro) FROM livro
GO

SELECT nome, preco_livro FROM livro
WHERE preco_livro = (SELECT MAX(preco_livro) FROM livro)
GO

SELECT nome,preco_livro FROM livro
GO


// /* UTILIZANDO O MIN */

SELECT nome, preco_livro FROM livro
WHERE preco_livro = (SELECT MIN(preco_livro) FROM livro)
GO

SELECT nome,preco_livro FROM livro
GO


// /* UTILIZANDO O AVG */
SELECT nome, preco_livro FROM livro
WHERE preco_livro > (SELECT AVG(preco_livro) FROM livro)
GO

SELECT AVG(preco_livro) AS Média FROM livro
GO

SELECT nome, preco_livro FROM livro
WHERE preco_livro < (SELECT AVG(preco_livro) FROM livro)
GO

-- GROUP BY
SELECT ID_editora FROM livro
GROUP BY ID_editora
GO


-- COUNT
SELECT ID_editora, COUNT(ID_editora) FROM livro
GROUP BY ID_editora
GO


SELECT ID_editora, COUNT(*) FROM livro
GROUP BY ID_editora 
GO

SELECT ID_editora, COUNT(*) FROM livro
GROUP BY ID_editora HAVING COUNT (*) > 0
GO

SELECT ID_editora, COUNT(*) AS Quantidade FROM livro
GROUP BY ID_editora 
GO

-- FILTROS

SELECT * FROM livro
WHERE preco_livro > 45
GO


SELECT * FROM livro
WHERE ID_livro % 2 = 0
GO

SELECT * FROM livro
WHERE ID_livro % 2 = 1
GO


-- DISTINCT

SELECT ID_editora FROM livro ORDER BY ID_editora
GO

SELECT DISTINCT ID_editora FROM livro ORDER BY ID_editora
GO

-- DISTINCT E GROUP BY

SELECT DISTINCT ID_editora FROM livro
GO

SELECT ID_editora,COUNT(*) FROM livro GROUP BY ID_editora
GO

-- EXERCICIO

-- QUESTÃO 1

DELETE FROM editora_copia
WHERE ID_editora % 2 = 1
GO

-- QUESTÃO 2

SELECT ID_autor,COUNT(*) FROM autor_copia
GROUP BY ID_autor HAVING ID_autor % 2 = 0
GO

-- TOP
SELECT TOP(5) nome,preco_livro FROM livro
GO


SELECT TOP() nome,preco_livro FROM livro
GO

SELECT nome,preco_livro FROM livro
ORDER BY preco_livro DESC
GO

SELECT ID_livro,nome,preco_livro FROM livro
ORDER BY preco_livro DESC
GO



SELECT ID_livro,nome,preco_livro FROM livro
ORDER BY preco_livro DESC
GO

-- TOP COM WITH TIES

SELECT TOP(3) WITH TIES ID_livro,nome,preco_livro FROM livro
ORDER BY preco_livro DESC
GO



------ SUBQUERY ---------

SELECT Resultado.editora, SUM(Resultado.PrecoLivro) AS total FROM

(SELECT e.nome AS Editora, l.preco_livro AS PrecoLivro
	FROM livro l
	INNER JOIN editora e
		ON l.ID_editora = e.ID_editora) AS Resultado
GROUP BY Resultado.editora
GO

-- JOINS
SELECT * FROM livro
GO
SELECT * FROM autor
GO
SELECT * FROM editora
GO

SELECT l.nome AS 'Nome Livro', a.nome AS 'Autor Nome', a.sobrenome AS 'Autor Sobrenome', e.nome AS 'Nome Editora'
	FROM livro l
	LEFT JOIN editora e 
		ON e.ID_editora = l.ID_editora
	LEFT JOIN autor a 
		ON a.ID_autor = l.ID_autor
GO

-- UTILIZA-SE O RIGHT SEMPRE QUE QUER PRIORIZAR TUDO QUE VEM APOS O JOIN

SELECT l.nome AS 'Nome Livro', a.nome AS 'Autor Nome', a.sobrenome AS 'Autor Sobrenome', e.nome AS 'Nome Editora'
	FROM livro l
	RIGHT JOIN editora e 
		ON e.ID_editora = l.ID_editora
	RIGHT JOIN autor a 
		ON a.ID_autor = l.ID_autor
GO

-- UNION ALL - ex: UNION DEVE UTILIZAR AS VARIANTES IGUAL (INT = INT) (CHAR = CHAR)
SELECT ID_livro, nome FROM livro
UNION ALL
SELECT ID_editora, nome FROM editora
GO

SELECT nome FROM livro WHERE ID_livro % 2 = 1
UNION ALL
SELECT nome FROM editora WHERE ID_editora % 2 = 1
GO

SELECT * FROM livro
GO

-- UTILIZANDO O UNION


SELECT l.ID_livro, l.nome, e.ID_editora,e.nome 
FROM livro l
	RIGHT JOIN editora e
	ON l.ID_editora = e.ID_editora
 UNION
SELECT l.ID_livro, l.nome, e.ID_editora,e.nome 
FROM livro l
	LEFT JOIN editora e
	ON l.ID_editora = e.ID_editora
GO


-- CRIANDO A VIEW

CREATE VIEW vw_todoslivros AS
SELECT l.nome AS NomeLivro, e.nome AS NomeEditora, a.nome AS NomeAutor
FROM livro l
	LEFT JOIN editora e
	ON l.ID_editora = e.ID_editora
	LEFT JOIN autor a
	ON a.ID_autor = l.ID_autor
GO

-- CRIANDO TRIGGER
CREATE OR ALTER TRIGGER tr_update
	ON livro
	AFTER UPDATE,INSERT AS

		IF UPDATE(nome)
			BEGIN
				PRINT 'UPDATE com sucesso'
			END
		ELSE
			BEGIN
				PRINT 'UPDATE NÃO realizado'
			END
GO

SELECT * FROM livro
GO

-- FAZENDO O UPDATE e PARA VER SE A TRIGGER FUNCIONOU
UPDATE livro
SET nome = 'O Hobbit a Volta'
WHERE ID_livro = '1'
GO

-- VISUALIZAÇÃO DE TRIGGER EXISTENTES
EXEC sp_helptrigger  'dbo.livro'
GO

-- DROPANDO TRIGGER
DROP TRIGGER tr_hello_world
GO
