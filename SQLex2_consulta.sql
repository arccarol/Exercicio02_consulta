CREATE DATABASE Filmes
GO 
USE Filmes
GO 
CREATE TABLE filme (
id INT NOT NULL,
titulo VARCHAR(40) NOT NULL,
ano INT  CHECK (ano <= 2021)
PRIMARY KEY(id)
)
GO 
CREATE TABLE DVD (
num INT NOT NULL,
data_fabricacao DATE NOT NULL CHECK (data_fabricacao < GETDATE()),
id INT NOT NULL
PRIMARY KEY(num)
FOREIGN KEY(id) REFERENCES filme(id)
)
GO 
CREATE TABLE estrela (
id_estre INT NOT NULL,
nome VARCHAR(50) NOT NULL
PRIMARY KEY(id_estre)
)
GO 

CREATE TABLE cliente(
num_cadastro INT NOT NULL,
nome VARCHAR(70) NOT NULL,
logradouro VARCHAR(150) NOT NULL,
num INT NOT NULL CHECK (num> 0),
cep CHAR(08),
PRIMARY KEY (num_cadastro) 
)
GO 
CREATE TABLE locacao (
data_locacao DATE NOT NULL DEFAULT GETDATE(),
data_devolucao DATE NOT NULL,
valor DECIMAL(7, 2) NOT NULL CHECK (valor> 0),
num INT NOT NULL,
num_cadastro INT NOT NULL
FOREIGN KEY(num) REFERENCES DVD(num),
FOREIGN KEY(num_cadastro) REFERENCES cliente(num_cadastro),
CONSTRAINT data_dev_loca CHECK (data_devolucao > data_locacao)
)
GO 
CREATE TABLE filme_estrela(
id INT NOT NULL,
id_estre INT NOT NULL
FOREIGN KEY(id) REFERENCES filme(id),
FOREIGN KEY(id_estre) REFERENCES estrela(id_estre)
)

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80);

INSERT INTO filme VALUES 
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A culpa é das estrelas', 2014),
(1005, 'Alexandre e o dia Terrivel, horrivel, espantoso e horroroso', 2014),
(1006, 'Sing', 2016)

ALTER TABLE estrela
ADD nome_real VARCHAR(50);

INSERT INTO estrela VALUES 
(9901, 'Michael Keaton', 'Michael john douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', 'NULL'),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')


INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

INSERT INTO DVD VALUES
(10001, '02-12-2020', 1001),
(10002, '18-10-2019', 1002),
(10003, '03-04-2020', 1003),
(10004, '02-12-2020', 1001),
(10005, '18-10-2019', 1004),
(10006, '03-04-2020', 1002),
(10007, '02-12-2020', 1005),
(10008, '18-10-2019', 1002),
(10009, '03-04-2020', 1003)

INSERT INTO cliente VALUES 
(5501, 'Matilde Luz', 'Rua Siria', 150, 03086040),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires ', 1250, 04419110),
(5503, 'Daniel Ramalho', 'Rua itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua jayme von rosenbuerg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simoes Pinto', 235, '02917110')

INSERT INTO locacao VALUES 
('18-02-2021', '21-02-2021', 3.50, 10001, 5502),
('18-02-2021', '21-02-2021', 3.50, 10009, 5502),
('18-02-2021', '19-02-2021', 3.50, 10002, 5503),
('20-02-2021', '23-02-2021', 3.00, 10002, 5505),
('20-02-2021', '23-02-2021', 3.00, 10004, 5505),
('20-02-2021', '23-02-2021', 3.00, 10005, 5505),
('24-02-2021', '26-02-2021', 3.50, 10001, 5501),
('24-02-2021', '26-02-2021', 3.50, 10008, 5501)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503;

UPDATE locacao
SET valor = 3.25
WHERE num_cadastro = 5502;

UPDATE locacao
SET valor = 3.10
WHERE num_cadastro = 5501;

UPDATE DVD
SET data_fabricacao = '14-07-2019'
WHERE num = 10005;

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller';


DELETE FROM filme
WHERE titulo = 'Sing';

SELECT titulo
FROM filme
WHERE ano = 2014;

SELECT id, ano
FROM filme
WHERE Titulo = 'Birdman';

SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'

SELECT id_estre, nome, nome_real
FROM estrela
WHERE Nome LIKE 'Steve%';

SELECT id, CONVERT(VARCHAR(10), data_fabricacao, 103) AS fab
FROM DVD
WHERE data_fabricacao >= '2020-01-01';

SELECT num, data_locacao, data_devolucao, valor, (valor + 2.00) AS valor_com_multa
FROM locacao
WHERE num_cadastro = 5505;

SELECT logradouro, num, cep
FROM cliente
WHERE nome = 'Matilde Luz';

SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton';

SELECT num_cadastro, nome, CONCAT(logradouro, ', ', num, ' ', cep) AS end_comp
FROM cliente
WHERE num_cadastro >= 5503;

SELECT F.ID, F.Ano, 
    CASE
        WHEN LEN(F.titulo) > 10 THEN LEFT(F.titulo, 10) + '...'
        ELSE F.titulo
    END AS Nome_do_Filme
FROM filme AS F
INNER JOIN DVD AS D ON F.id = D.id
WHERE D.data_fabricacao > '2020-01-01';


SELECT D.num, D.data_fabricacao, 
    DATEDIFF(MONTH, D.data_fabricacao, GETDATE()) AS qtd_meses_desde_fabricacao
FROM DVD AS D
INNER JOIN filme AS F ON D.id = F.id
WHERE F.titulo = 'Interestelar';


SELECT D.num, L.data_locacao, L.data_devolucao,
    DATEDIFF(day, L.data_locacao, L.data_devolucao) AS dias_alugado,
    L.valor
FROM locacao AS L
JOIN cliente AS C ON L.num_cadastro = C.num_cadastro
JOIN DVD AS D ON L.num = D.num
WHERE C.nome LIKE '%Rosa%';

SELECT C.Nome, 
    CONCAT(C.logradouro, ' ', C.num) AS endereço_completo, 
    SUBSTRING(c.cep,1,5) + '-' + SUBSTRING(c.cep,6,3) AS cep
FROM cliente AS C
JOIN locacao AS L ON C.num_cadastro = L.num_cadastro
JOIN DVD AS D ON L.num = D.num
WHERE D.num = 10002;