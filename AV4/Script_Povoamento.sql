TRUNCATE TABLE UsoViatura;
TRUNCATE TABLE Atende;
TRUNCATE TABLE Supervisiona;
TRUNCATE TABLE Aciona;
TRUNCATE TABLE PecasTrocadas;
TRUNCATE TABLE ManutencaoViatura;
TRUNCATE TABLE Ocorrencia;
TRUNCATE TABLE TelefoneQuartel;
TRUNCATE TABLE AreaCoberturaQuartel;
TRUNCATE TABLE Viatura;
TRUNCATE TABLE Vitima;
TRUNCATE TABLE Bombeiro;
TRUNCATE TABLE TelefonePessoa;
TRUNCATE TABLE Quartel;
TRUNCATE TABLE Pessoa;
TRUNCATE TABLE Cep;

-- Povoamento Tabela Cep
INSERT INTO Cep (cep, rua, cidade) VALUES
('50000000', 'Rua Principal', 'Recife'),
('50010000', 'Avenida Central', 'Recife'),
('50020000', 'Praca da Matriz', 'Olinda'),
('50030000', 'Travessa dos Coqueiros', 'Recife'),
('50040000', 'Rua do Sol', 'Recife'),
('50050000', 'Avenida da Praia', 'Jaboatao'),
('50060000', 'Rua da Alegria', 'Olinda'),
('50070000', 'Travessa da Lua', 'Recife'),
('50080000', 'Rua do Porto', 'Recife'),
('50090000', 'Alameda das Flores', 'Paulista'),
('50100000', 'Beco da Saudade', 'Recife'),
('50110000', 'Avenida Rio Branco', 'Recife');

-- Povoamento Tabela Pessoa
INSERT INTO Pessoa (cpf, nome, data_nascimento, carteira_habilitacao) VALUES
('11111111111', 'Ana Silva', TO_DATE('1980-01-15', 'YYYY-MM-DD'), 'A'),
('22222222222', 'Bruno Costa', TO_DATE('1992-05-20', 'YYYY-MM-DD'), 'A'),
('33333333333', 'Carlos Souza', TO_DATE('1975-11-10', 'YYYY-MM-DD'), 'B'),
('44444444444', 'Diana Pereira', TO_DATE('2000-03-25', 'YYYY-MM-DD'), 'B'),
('55555555555', 'Eduardo Lima', TO_DATE('1988-07-01', 'YYYY-MM-DD'), 'C'),
('66666666666', 'Fernanda Goes', TO_DATE('1995-02-02', 'YYYY-MM-DD'), 'C'),
('77777777777', 'Gustavo Alves', TO_DATE('1982-09-18', 'YYYY-MM-DD'), 'D'),
('88888888888', 'Helena Dias', TO_DATE('1970-04-30', 'YYYY-MM-DD'), 'D'),
('99999999999', 'Igor Santos', TO_DATE('2001-12-12', 'YYYY-MM-DD'), 'A'),
('10000000000', 'Julia Oliveira', TO_DATE('1990-06-05', 'YYYY-MM-DD'), 'B'),
('11000000000', 'Kleber Rocha', TO_DATE('1983-08-28', 'YYYY-MM-DD'), 'C'),
('12000000000', 'Larissa Mendes', TO_DATE('1998-10-07', 'YYYY-MM-DD'), 'D'),
('13000000000', 'Marcos Nunes', TO_DATE('1973-01-20', 'YYYY-MM-DD'), 'D'),
('14000000000', 'Natalia Pinto', TO_DATE('1987-03-11', 'YYYY-MM-DD'), 'A'),
('15000000000', 'Otavio Castro', TO_DATE('1994-07-29', 'YYYY-MM-DD'), 'A');

-- Povoamento Tabela TelefonePessoa
INSERT INTO TelefonePessoa (cpf, ddd, numero) VALUES
('11111111111', '81', '991234567'),
('11111111111', '81', '33445566'),
('22222222222', '81', '998765432'),
('33333333333', '81', '993332211'),
('66666666666', '82', '990001122'),
('66666666666', '82', '30004455'),
('77777777777', '83', '995556677'),
('88888888888', '83', '991110000'),
('99999999999', '83', '992223344'),
('10000000000', '83', '994445566'),
('11000000000', '81', '38887766'),
('12000000000', '82', '997778899'),
('13000000000', '83', '35554433'),
('14000000000', '81', '996665544'),
('15000000000', '81', '31112233');

-- Povoamento Tabela Quartel
INSERT INTO Quartel (cnpj, cep, nome, numero, complemento, comandante_responsavel) VALUES
('00000000000101', '50000000', 'Quartel Central de Recife', 100, 'Bloco A', 'Cel. Francisco Mendes'),
('00000000000202', '50010000', 'Quartel Zona Norte', 250, 'Andar 2', 'Maj. Fernanda Santos'),
('00000000000303', '50020000', 'Quartel de Olinda', 10, NULL, 'Cap. Roberto Junior'),
('00000000000404', '50040000', 'Quartel Sul', 50, 'Sala 10', 'Cel. Marcia Lima'),
('00000000000505', '50050000', 'Quartel Jaboatao', 300, NULL, 'Maj. Pedro Nogueira'),
('00000000000606', '50060000', 'Quartel Olinda-Norte', 15, 'Prox. Rodoviaria', 'Cap. Joana Darc');

-- Povoamento Tabela Bombeiro
INSERT INTO Bombeiro (cpf, cnpj, posto, tempo_servico, funcao) VALUES
('11111111111', '00000000000101', 'Sargento', 10, 'Chefe de Equipe'),
('22222222222', '00000000000101', 'Cabo', 5, 'Motorista'),
('33333333333', '00000000000202', 'Tenente', 12, 'Comandante de Pelotao'),
('66666666666', '00000000000404', 'Soldado', 2, 'Resgatista'),
('77777777777', '00000000000404', 'Cabo', 6, 'Operador de Equipamentos'),
('88888888888', '00000000000505', 'Sargento', 15, 'Instrutor'),
('99999999999', '00000000000505', 'Soldado', 1, 'Auxiliar'),
('10000000000', '00000000000606', 'Tenente', 8, 'Chefe de Turno'),
('11000000000', '00000000000606', 'Cabo', 4, 'Comunicacoes');

-- Povoamento Tabela Vitima
INSERT INTO Vitima (cpf, grau_risco, observacoes) VALUES
('44444444444', 'Medio', 'Pequenas escoriacoes, recusou atendimento hospitalar.'),
('55555555555', 'Alto', 'Vitima inconsciente, encaminhada para emergencia.'),
('12000000000', 'Baixo', 'Sem ferimentos aparentes.'),
('13000000000', 'Grave', 'Fratura exposta, hemorragia.'),
('14000000000', 'Medio', 'Sintomas de inalacao de fumaca.');

-- Povoamento Tabela Viatura
INSERT INTO Viatura (placa, cnpj, tipo, estado) VALUES
('KGF1234', '00000000000101', 'Carro de Bombeiros', 'Operacional'),
('ABC5678', '00000000000101', 'Ambulancia', 'Em Manutencao'),
('XYZ9012', '00000000000202', 'Ambulancia', 'Operacional'),
('GHI3456', '00000000000404', 'Carro de Bombeiros', 'Operacional'),
('LMN7890', '00000000000404', 'Carro de Bombeiros', 'Operacional'),
('OPQ1234', '00000000000505', 'Carro de Bombeiros', 'Operacional'),
('RST5678', '00000000000505', 'Carro Comando', 'Operacional'),
('UVW9012', '00000000000606', 'Ambulancia', 'Em Manutencao'),
('ZAB3456', '00000000000606', 'Ambulancia', 'Operacional');

-- Povoamento Tabela AreaCoberturaQuartel
INSERT INTO AreaCoberturaQuartel (cnpj, cidade, bairro) VALUES
('00000000000101', 'Recife', 'Boa Viagem'),
('00000000000101', 'Recife', 'Centro'),
('00000000000202', 'Recife', 'Casa Amarela'),
('00000000000404', 'Recife', 'Pina'),
('00000000000404', 'Recife', 'Imbiribeira'),
('00000000000505', 'Jaboatao', 'Piedade'),
('00000000000505', 'Jaboatao', 'Candeias'),
('00000000000606', 'Olinda', 'Bairro Novo'),
('00000000000606', 'Olinda', 'Casa Caiada'),
('00000000000101', 'Recife', 'Madalena'),
('00000000000202', 'Recife', 'Boa Vista'),
('00000000000303', 'Olinda', 'Varadouro');

-- Povoamento Tabela TelefoneQuartel
INSERT INTO TelefoneQuartel (cnpj, ddd, numero) VALUES
('00000000000101', '81', '32221100'),
('00000000000101', '81', '32221101'),
('00000000000202', '81', '34567890'),
('00000000000404', '81', '33334455'),
('00000000000404', '81', '33334456'),
('00000000000505', '81', '37778899'),
('00000000000606', '81', '30009988');

-- Povoamento Tabela Ocorrencia (INSERT INTO tem que ser chamado várias vezes individualmente para que a contagem do sequence funcione)
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50000000', 350, NULL, TO_DATE('2025-06-20', 'YYYY-MM-DD'), 'Incendio Residencial', 'Incendio em apartamento no 5o andar.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50010000', 120, 'Fundos', TO_DATE('2025-06-21', 'YYYY-MM-DD'), 'Acidente de Transito', 'Colisao entre carro e moto.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50030000', 50, 'Apto 101', TO_DATE('2025-06-22', 'YYYY-MM-DD'), 'Resgate de Animal', 'Gato preso em arvore.');    
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50040000', 200, NULL, TO_DATE('2025-06-23', 'YYYY-MM-DD'), 'Inundacao', 'Vazamento de tubulacao em predio comercial.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50050000', 80, 'Casa 2', TO_DATE('2025-06-24', 'YYYY-MM-DD'), 'Resgate de Animal', 'Cachorro atropelado em via publica.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50060000', 150, NULL, TO_DATE('2025-06-25', 'YYYY-MM-DD'), 'Incendio Residencial', 'Incendio em apartamento no 3o andar.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50070000', 45, 'Loja B', TO_DATE('2025-06-26', 'YYYY-MM-DD'), 'Atendimento Pre-Hospitalar', 'Mal subido em via publica.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50080000', 10, NULL, TO_DATE('2025-06-27', 'YYYY-MM-DD'), 'Incendio Residencial', 'Incendio em apartamento no 1o andar.');
INSERT INTO Ocorrencia (protocolo,cep, numero, complemento, data, tipo, descricao) VALUES
(ocorrencia_seq.nextval,'50090000', 75, 'Andar 3', TO_DATE('2025-06-28', 'YYYY-MM-DD'), 'Vazamento de Gas', 'Odor forte de gas em condominio.');

-- Povoamento Tabela ManutencaoViatura
INSERT INTO ManutencaoViatura (codigo, placa, tipo, data, horario_atendimento, observacoes) VALUES
('MANUT001', 'ABC5678', 'Preventiva', TO_DATE('2025-06-10', 'YYYY-MM-DD'), '09:00:00', 'Troca de oleo e filtros.'),
('MANUT002', 'KGF1234', 'Corretiva', TO_DATE('2025-06-15', 'YYYY-MM-DD'), '14:30:00', 'Reparo no sistema de freios.'),
('MANUT003', 'GHI3456', 'Preventiva', TO_DATE('2025-06-18', 'YYYY-MM-DD'), '10:00:00', 'Revisao geral.'),
('MANUT004', 'OPQ1234', 'Corretiva', TO_DATE('2025-06-20', 'YYYY-MM-DD'), '11:00:00', 'Conserto de motor.'),
('MANUT005', 'OPQ1234', 'Preventiva', TO_DATE('2025-06-22', 'YYYY-MM-DD'), '13:00:00', 'Inspecao de seguranca.'),
('MANUT006', 'ABC5678', 'Corretiva', TO_DATE('2025-06-24', 'YYYY-MM-DD'), '16:00:00', 'Troca de pneus.');

-- Povoamento Tabela PecasTrocadas
INSERT INTO PecasTrocadas (codigo, placa, peca) VALUES
('MANUT001', 'ABC5678', 'Filtro de Oleo'),
('MANUT001', 'ABC5678', 'Filtro de Ar'),
('MANUT002', 'KGF1234', 'Pastilha de Freio'),
('MANUT002', 'KGF1234', 'Disco de Freio'),
('MANUT003', 'GHI3456', 'Vela de Ignicao'),
('MANUT003', 'GHI3456', 'Correia Dentada'),
('MANUT004', 'OPQ1234', 'Bomba de Combustivel'),
('MANUT004', 'OPQ1234', 'Radiador'),
('MANUT005', 'OPQ1234', 'Bateria'),
('MANUT005', 'OPQ1234', 'Lampada Farol'),
('MANUT006', 'ABC5678', 'Pneu Dianteiro D'),
('MANUT006', 'ABC5678', 'Pneu Traseiro E');

-- Povoamento Tabela Aciona
INSERT INTO Aciona (protocolo, cpf) VALUES
(1, '44444444444'),
(2, '11111111111'),
(3, '66666666666'),
(4, '77777777777'),
(5, '88888888888'),
(6, '99999999999'),
(7, '10000000000'),
(8, '11000000000'),
(9, '12000000000');

-- Povoamento Tabela Supervisiona
INSERT INTO Supervisiona (supervisor, supervisionado) VALUES
('11111111111', '22222222222'),
('33333333333', '66666666666'),
('33333333333', '77777777777'),
('88888888888', '99999999999'),
('10000000000', '11000000000');

-- Povoamento Tabela Atende
INSERT INTO Atende (bombeiro, pessoa, protocolo) VALUES
('11111111111', '44444444444', 1),
('22222222222', '44444444444', 1),
('33333333333', '55555555555', 2),
('66666666666', '12000000000', 3),
('77777777777', '13000000000', 4),
('88888888888', '14000000000', 5),
('11111111111', '12000000000', 6),
('22222222222', '13000000000', 7),
('33333333333', '14000000000', 8);

-- Povoamento Tabela UsoViatura
INSERT INTO UsoViatura (placa, protocolo, distancia_percorrida, hora_chegada, hora_saida) VALUES
('KGF1234', 1, 15.50, '09:15:00', '11:00:00'),
('ABC5678', 1, 14.00, '09:20:00', '11:00:00'),
('XYZ9012', 2, 8.20, '14:45:00', '15:30:00'),
('GHI3456', 3, 5.00, '10:00:00', '10:45:00'),
('LMN7890', 4, 22.30, '08:30:00', '12:00:00'),
('OPQ1234', 5, 10.10, '13:00:00', '14:00:00'),
('KGF1234', 6, 7.80, '16:00:00', '17:00:00'),
('XYZ9012', 7, 12.00, '09:00:00', '10:00:00'),
('GHI3456', 8, 3.50, '11:30:00', '12:15:00');
