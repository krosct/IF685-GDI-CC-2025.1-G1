
-- DROP DE ELEMENTOS QUE JÁ POSSAM EXISTIR ANTERIOMENTE
DROP SEQUENCE ocorrencia_seq;

DROP TABLE UsoViatura;
DROP TABLE Atende;
DROP TABLE Supervisiona;
DROP TABLE Aciona;
DROP TABLE PecasTrocadas;
DROP TABLE ManutencaoViatura;
DROP TABLE Ocorrencia;
DROP TABLE TelefoneQuartel;
DROP TABLE AreaCoberturaQuartel;
DROP TABLE Viatura;
DROP TABLE Vitima;
DROP TABLE Bombeiro;
DROP TABLE TelefonePessoa;
DROP TABLE Quartel;
DROP TABLE Pessoa;
DROP TABLE Cep;

-- CRIAÇÃO DA SEQUENCE PARA OCORRENCIA
CREATE SEQUENCE ocorrencia_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

-- Tabela Cep
CREATE TABLE Cep (
    cep VARCHAR2(8) CONSTRAINT pk_cep PRIMARY KEY,
    rua VARCHAR2(255) CONSTRAINT nn_cep_rua NOT NULL,
    cidade VARCHAR2(255) CONSTRAINT nn_cep_cidade NOT NULL
);

-- Tabela Pessoa
CREATE TABLE Pessoa (
    cpf VARCHAR2(11) CONSTRAINT pk_pessoa PRIMARY KEY,
    nome VARCHAR2(255) CONSTRAINT nn_pessoa_nome NOT NULL,
    data_nascimento DATE,
    carteira_habilitacao VARCHAR2(1)
        CONSTRAINT chk_pessoa_cnh CHECK (carteira_habilitacao IN ('A', 'B', 'C', 'D', 'E'))
);

-- Tabela TelefonePessoa
CREATE TABLE TelefonePessoa (
    cpf VARCHAR2(11),
    ddd VARCHAR2(3),
    numero VARCHAR2(9),
    CONSTRAINT pk_telefonepessoa PRIMARY KEY (cpf, ddd, numero),
    CONSTRAINT fk_telefonepessoa_cpf FOREIGN KEY (cpf) REFERENCES Pessoa(cpf)
);

-- Tabela Quartel
CREATE TABLE Quartel (
    cnpj VARCHAR2(14) CONSTRAINT pk_quartel PRIMARY KEY,
    cep VARCHAR2(8) CONSTRAINT nn_quartel_cep NOT NULL,
    nome VARCHAR2(255) CONSTRAINT nn_quartel_nome NOT NULL,
    numero NUMBER(5)
        CONSTRAINT chk_quartel_numero CHECK (numero > 0),
    complemento VARCHAR2(255),
    comandante_responsavel VARCHAR2(255),
    CONSTRAINT fk_quartel_cep FOREIGN KEY (cep) REFERENCES Cep(cep)
);

-- Tabela Bombeiro
CREATE TABLE Bombeiro (
    cpf VARCHAR2(11) CONSTRAINT pk_bombeiro PRIMARY KEY,
    cnpj VARCHAR2(14) CONSTRAINT nn_bombeiro_cnpj NOT NULL,
    posto VARCHAR2(50),
    tempo_servico NUMBER(4) CONSTRAINT chk_bombeiro_tempo_servico CHECK (tempo_servico >= 0),
    funcao VARCHAR2(255),
    CONSTRAINT fk_bombeiro_cpf FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
    CONSTRAINT fk_bombeiro_cnpj FOREIGN KEY (cnpj) REFERENCES Quartel(cnpj)
);

-- Tabela Vítima
CREATE TABLE Vitima (
    cpf VARCHAR2(11) CONSTRAINT pk_vitima PRIMARY KEY,
    grau_risco VARCHAR2(50)
        CONSTRAINT chk_vitima_grau_risco CHECK (grau_risco IN ('Baixo', 'Medio', 'Alto', 'Grave')),
    observacoes VARCHAR2(255),
    CONSTRAINT fk_vitima_cpf FOREIGN KEY (cpf) REFERENCES Pessoa(cpf)
);

-- Tabela Viatura
CREATE TABLE Viatura (
    placa VARCHAR2(7) CONSTRAINT pk_viatura PRIMARY KEY,
    cnpj VARCHAR2(14) CONSTRAINT nn_viatura_cnpj NOT NULL,
    tipo VARCHAR2(50),
    estado VARCHAR2(50)
        CONSTRAINT chk_viatura_estado CHECK (estado IN ('Operacional', 'Em Manutencao')),
    CONSTRAINT fk_viatura_cnpj FOREIGN KEY (cnpj) REFERENCES Quartel(cnpj)
);

-- Tabela AreaCoberturaQuartel
CREATE TABLE AreaCoberturaQuartel (
    cnpj VARCHAR2(14),
    cidade VARCHAR2(255),
    bairro VARCHAR2(255),
    CONSTRAINT pk_areacoberturaquartel PRIMARY KEY (cnpj, cidade, bairro),
    CONSTRAINT fk_areacoberturaquartel_cnpj FOREIGN KEY (cnpj) REFERENCES Quartel(cnpj)
);

-- Tabela TelefoneQuartel
CREATE TABLE TelefoneQuartel (
    cnpj VARCHAR2(14),
    ddd VARCHAR2(3),
    numero VARCHAR2(9),
    CONSTRAINT pk_telefonequartel PRIMARY KEY (cnpj, ddd, numero),
    CONSTRAINT fk_telefonequartel_cnpj FOREIGN KEY (cnpj) REFERENCES Quartel(cnpj)
);

-- Tabela Ocorrencia (protocolo é GENERATED ALWAYS AS IDENTITY)
CREATE TABLE Ocorrencia (
    protocolo NUMBER(10) GENERATED ALWAYS AS IDENTITY CONSTRAINT pk_ocorrencia PRIMARY KEY,
    cep VARCHAR2(8) CONSTRAINT nn_ocorrencia_cep NOT NULL,
    numero NUMBER(5),
        CONSTRAINT chk_ocorrencia_numero CHECK (numero > 0),
    complemento VARCHAR2(255),
    data DATE,
    tipo VARCHAR2(255),
    descricao VARCHAR2(255),
    CONSTRAINT fk_ocorrencia_cep FOREIGN KEY (cep) REFERENCES Cep(cep)
);

-- Tabela ManutencaoViatura
CREATE TABLE ManutencaoViatura (
    codigo VARCHAR2(20),
    placa VARCHAR2(7),
    tipo VARCHAR2(255),
    data DATE,
    horario_atendimento VARCHAR2(8),
    observacoes VARCHAR2(255),
    CONSTRAINT pk_manutencaoviatura PRIMARY KEY (codigo, placa),
    CONSTRAINT fk_manutencaoviatura_placa FOREIGN KEY (placa) REFERENCES Viatura(placa)
);

-- Tabela PecasTrocadas
CREATE TABLE PecasTrocadas (
    codigo VARCHAR2(20),
    placa VARCHAR2(7),
    peca VARCHAR2(255),
    CONSTRAINT pk_pecastrocadas PRIMARY KEY (codigo, placa, peca),
    CONSTRAINT fk_pecastrocadas_manut FOREIGN KEY (codigo, placa) REFERENCES ManutencaoViatura(codigo, placa)
);

-- Tabela Aciona
CREATE TABLE Aciona (
    protocolo NUMBER(10),
    cpf VARCHAR2(11),
    CONSTRAINT pk_aciona PRIMARY KEY (protocolo, cpf),
    CONSTRAINT fk_aciona_ocorrencia FOREIGN KEY (protocolo) REFERENCES Ocorrencia(protocolo),
    CONSTRAINT fk_aciona_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa(cpf)
);

-- Tabela Supervisiona
CREATE TABLE Supervisiona (
    supervisor VARCHAR2(11),
    supervisionado VARCHAR2(11),
    CONSTRAINT pk_supervisiona PRIMARY KEY (supervisor, supervisionado),
    CONSTRAINT fk_supervisiona_supervisor FOREIGN KEY (supervisor) REFERENCES Bombeiro(cpf),
    CONSTRAINT fk_supervisiona_supervisionado FOREIGN KEY (supervisionado) REFERENCES Bombeiro(cpf)
);

-- Tabela Atende
CREATE TABLE Atende (
    bombeiro VARCHAR2(11),
    pessoa VARCHAR2(11),
    protocolo NUMBER(10),
    CONSTRAINT pk_atende PRIMARY KEY (bombeiro, pessoa, protocolo),
    CONSTRAINT fk_atende_bombeiro FOREIGN KEY (bombeiro) REFERENCES Bombeiro(cpf),
    CONSTRAINT fk_atende_pessoa FOREIGN KEY (pessoa) REFERENCES Pessoa(cpf),
    CONSTRAINT fk_atende_ocorrencia FOREIGN KEY (protocolo) REFERENCES Ocorrencia(protocolo)
);

-- Tabela UsoViatura
CREATE TABLE UsoViatura (
    placa VARCHAR2(7),
    protocolo NUMBER(10),
    distancia_percorrida NUMBER(10,2),
    hora_chegada VARCHAR2(8),
    hora_saida VARCHAR2(8),
    CONSTRAINT pk_usoviatura PRIMARY KEY (placa, protocolo),
    CONSTRAINT fk_usoviatura_viatura FOREIGN KEY (placa) REFERENCES Viatura(placa),
    CONSTRAINT fk_usoviatura_ocorrencia FOREIGN KEY (protocolo) REFERENCES Ocorrencia(protocolo)
);
