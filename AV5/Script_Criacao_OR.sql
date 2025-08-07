-- DROP DE ELEMENTOS QUE JÁ POSSAM EXISTIR ANTERIORMENTE
DROP SEQUENCE ocorrencia_seq;

DROP TABLE tb_ocorrencias;
DROP TABLE tb_viaturas;
DROP TABLE tb_quarteis;
DROP TABLE tb_pessoas;

DROP TYPE tp_ocorrencia FORCE;
DROP TYPE tp_manutencao_nt FORCE;
DROP TYPE tp_manutencao FORCE;
DROP TYPE tp_peca_trocada_nt FORCE;
DROP TYPE tp_peca_trocada FORCE;
DROP TYPE tp_viatura FORCE;
DROP TYPE tp_bombeiro FORCE;
DROP TYPE tp_vitima FORCE;
DROP TYPE tp_pessoa FORCE;
DROP TYPE tp_quartel FORCE;
DROP TYPE tp_telefone_va FORCE;
DROP TYPE tp_telefone FORCE;
DROP TYPE tp_endereco FORCE;

-- CRIAÇÃO DA SEQUENCE PARA OCORRENCIA
CREATE SEQUENCE ocorrencia_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

-- Tipo para Endereço
CREATE OR REPLACE TYPE tp_endereco AS OBJECT (
    cep VARCHAR2(8),
    rua VARCHAR2(255),
    cidade VARCHAR2(255),
    numero NUMBER(5),
    complemento VARCHAR2(255)
);
/

-- Tipo para Telefone
CREATE OR REPLACE TYPE tp_telefone AS OBJECT (
    ddd VARCHAR2(3),
    numero VARCHAR2(9)
);
/

CREATE OR REPLACE TYPE tp_telefone_va AS VARRAY(2) OF tp_telefone;
/

-- Tipo base para Pessoa
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(9), -- Valor incorreto para ser corrigido posteriormente com ALTER TYPE
    nome VARCHAR2(255),
    data_nascimento DATE,
    carteira_habilitacao VARCHAR2(1),

    MAP MEMBER FUNCTION get_cpf RETURN VARCHAR2,
    MEMBER FUNCTION exibir_info RETURN VARCHAR2,
    FINAL MEMBER FUNCTION get_idade RETURN NUMBER

) NOT INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY tp_pessoa AS
    MAP MEMBER FUNCTION get_cpf RETURN VARCHAR2 IS
    BEGIN
        RETURN self.cpf;
    END;

    MEMBER FUNCTION exibir_info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'CPF: ' || self.cpf || ', Nome: ' || self.nome;
    END;

    FINAL MEMBER FUNCTION get_idade RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, self.data_nascimento) / 12);
    END;
END;
/

-- Tipo para Quartel
CREATE OR REPLACE TYPE tp_quartel AS OBJECT (
    cnpj VARCHAR2(14),
    nome VARCHAR2(255),
    endereco tp_endereco,
    telefones tp_telefone_va,
    comandante_responsavel VARCHAR2(255)
);
/

-- Tipo para Bombeiro
CREATE OR REPLACE TYPE tp_bombeiro UNDER tp_pessoa (
    posto VARCHAR2(50),
    tempo_servico NUMBER(4),
    funcao VARCHAR2(255),
    quartel_ref REF tp_quartel,

    CONSTRUCTOR FUNCTION tp_bombeiro(
        cpf VARCHAR2,
        nome VARCHAR2,
        data_nascimento DATE,
        carteira_habilitacao VARCHAR2,
        posto VARCHAR2,
        tempo_servico NUMBER,
        funcao VARCHAR2,
        quartel_ref REF tp_quartel
    ) RETURN SELF AS RESULT,

    OVERRIDING MEMBER FUNCTION exibir_info RETURN VARCHAR2,
    MEMBER PROCEDURE promover(novo_posto VARCHAR2)
);
/

CREATE OR REPLACE TYPE BODY tp_bombeiro AS
    CONSTRUCTOR FUNCTION tp_bombeiro(
        cpf VARCHAR2,
        nome VARCHAR2,
        data_nascimento DATE,
        carteira_habilitacao VARCHAR2,
        posto VARCHAR2,
        tempo_servico NUMBER,
        funcao VARCHAR2,
        quartel_ref REF tp_quartel
    ) RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.cpf := cpf;
        SELF.nome := nome;
        SELF.data_nascimento := data_nascimento;
        IF carteira_habilitacao IS NULL THEN
            SELF.carteira_habilitacao := '-';
        ELSE
            SELF.carteira_habilitacao := carteira_habilitacao;
        END IF;
        SELF.posto := posto;
        SELF.tempo_servico := tempo_servico;
        SELF.funcao := funcao;
        SELF.quartel_ref := quartel_ref;
        RETURN;
    END;

    OVERRIDING MEMBER FUNCTION exibir_info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Bombeiro: ' || self.nome || ', Posto: ' || self.posto || ', Função: ' || self.funcao;
    END;

    MEMBER PROCEDURE promover(novo_posto VARCHAR2) IS
    BEGIN
        SELF.posto := novo_posto;
    END;
END;
/

-- Tipo para Vítima
CREATE OR REPLACE TYPE tp_vitima UNDER tp_pessoa (
    grau_risco VARCHAR2(50),
    observacoes VARCHAR2(255),

    CONSTRUCTOR FUNCTION tp_vitima(
        cpf VARCHAR2,
        nome VARCHAR2,
        data_nascimento DATE,
        carteira_habilitacao VARCHAR2,
        grau_risco VARCHAR2,
        observacoes VARCHAR2
    ) RETURN SELF AS RESULT,

    OVERRIDING MEMBER FUNCTION exibir_info RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY tp_vitima AS
    CONSTRUCTOR FUNCTION tp_vitima(
        cpf VARCHAR2,
        nome VARCHAR2,
        data_nascimento DATE,
        carteira_habilitacao VARCHAR2,
        grau_risco VARCHAR2,
        observacoes VARCHAR2
    ) RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.cpf := cpf;
        SELF.nome := nome;
        SELF.data_nascimento := data_nascimento;
        IF carteira_habilitacao IS NULL THEN
            SELF.carteira_habilitacao := '-';
        ELSE
            SELF.carteira_habilitacao := carteira_habilitacao;
        END IF;
        SELF.grau_risco := grau_risco;
        SELF.observacoes := observacoes;
        RETURN;
    END;

    OVERRIDING MEMBER FUNCTION exibir_info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Vítima: ' || self.nome || ', Risco: ' || self.grau_risco;
    END;
END;
/

-- Tipo para Peças e Manutenção
CREATE OR REPLACE TYPE tp_peca_trocada AS OBJECT (
    peca VARCHAR2(255)
);
/

CREATE OR REPLACE TYPE tp_peca_trocada_nt AS TABLE OF tp_peca_trocada;
/

CREATE OR REPLACE TYPE tp_manutencao AS OBJECT (
    codigo VARCHAR2(20),
    tipo VARCHAR2(255),
    data_manutencao DATE,
    observacoes VARCHAR2(255),
    pecas_trocadas tp_peca_trocada_nt
);
/

-- Tipo para Viatura
CREATE OR REPLACE TYPE tp_manutencao_nt AS TABLE OF tp_manutencao;
/

CREATE OR REPLACE TYPE tp_viatura AS OBJECT (
    placa VARCHAR2(7),
    tipo VARCHAR2(50),
    estado VARCHAR2(50),
    quartel_ref REF tp_quartel,
    historico_manutencao tp_manutencao_nt,

    CONSTRUCTOR FUNCTION tp_viatura(
        placa VARCHAR2,
        tipo VARCHAR2,
        quartel_ref REF tp_quartel,
        estado VARCHAR2 DEFAULT 'Operacional'
    ) RETURN SELF AS RESULT,

    MEMBER FUNCTION is_operacional RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY tp_viatura AS
    CONSTRUCTOR FUNCTION tp_viatura(
        placa VARCHAR2,
        tipo VARCHAR2,
        quartel_ref REF tp_quartel,
        estado VARCHAR2 DEFAULT 'Operacional'
    ) RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.placa := placa;
        SELF.tipo := tipo;
        SELF.quartel_ref := quartel_ref;
        SELF.estado := estado;
        SELF.historico_manutencao := tp_manutencao_nt();

        RETURN;
    END;

    MEMBER FUNCTION is_operacional RETURN VARCHAR2 IS
    BEGIN
        IF self.estado = 'Operacional' THEN
            RETURN 'Sim';
        ELSE
            RETURN 'Não';
        END IF;
    END;
END;
/

-- Tipo para Ocorrência
CREATE OR REPLACE TYPE tp_ocorrencia AS OBJECT (
    protocolo NUMBER(10),
    endereco_ocorrencia tp_endereco,
    data_ocorrencia DATE,
    tipo VARCHAR2(255),
    descricao VARCHAR2(255),
    observacao_geral VARCHAR2(500),

    viaturas_usadas REF tp_viatura,
    bombeiros_atendimento REF tp_bombeiro,
    vitimas_atendidas REF tp_vitima,

    CONSTRUCTOR FUNCTION tp_ocorrencia(
        protocolo NUMBER,
        endereco_ocorrencia tp_endereco,
        data_ocorrencia DATE,
        tipo VARCHAR2,
        descricao VARCHAR2,
        viaturas_usadas REF tp_viatura,
        bombeiros_atendimento REF tp_bombeiro,
        vitimas_atendidas REF tp_vitima,
        observacao_geral VARCHAR2 DEFAULT 'Sem observação.'
    ) RETURN SELF AS RESULT,

    ORDER MEMBER FUNCTION comparar_data(o tp_ocorrencia) RETURN INTEGER
);
/

CREATE OR REPLACE TYPE BODY tp_ocorrencia AS
    CONSTRUCTOR FUNCTION tp_ocorrencia(
        protocolo NUMBER,
        endereco_ocorrencia tp_endereco,
        data_ocorrencia DATE,
        tipo VARCHAR2,
        descricao VARCHAR2,
        viaturas_usadas REF tp_viatura,
        bombeiros_atendimento REF tp_bombeiro,
        vitimas_atendidas REF tp_vitima,
        observacao_geral VARCHAR2 DEFAULT 'Sem observação.'
    ) RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.protocolo := protocolo;
        SELF.endereco_ocorrencia := endereco_ocorrencia;
        SELF.data_ocorrencia := data_ocorrencia;
        SELF.tipo := tipo;
        SELF.descricao := descricao;
        SELF.viaturas_usadas := viaturas_usadas;
        SELF.bombeiros_atendimento := bombeiros_atendimento;
        SELF.vitimas_atendidas := vitimas_atendidas;
        SELF.observacao_geral := observacao_geral;
        RETURN;
    END;

    ORDER MEMBER FUNCTION comparar_data(o tp_ocorrencia) RETURN INTEGER IS
    BEGIN
        IF self.data_ocorrencia < o.data_ocorrencia THEN
            RETURN -1;
        ELSIF self.data_ocorrencia > o.data_ocorrencia THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
END;
/

-- Tabela de Quarteis
CREATE TABLE tb_quarteis OF tp_quartel (
    cnpj PRIMARY KEY
)
/

-- Tabela de Pessoas
CREATE TABLE tb_pessoas OF tp_pessoa (
    cpf PRIMARY KEY
)
/

-- Tabela de Viaturas
CREATE TABLE tb_viaturas OF tp_viatura (
    placa PRIMARY KEY,
    SCOPE FOR (quartel_ref) IS tb_quarteis
) NESTED TABLE historico_manutencao STORE AS nt_historico_manutencao (
    NESTED TABLE pecas_trocadas STORE AS nt_pecas_trocadas
)
/

-- Tabela de Ocorrências
CREATE TABLE tb_ocorrencias OF tp_ocorrencia (
    protocolo PRIMARY KEY,
    SCOPE FOR (viaturas_usadas) IS tb_viaturas,
    SCOPE FOR (bombeiros_atendimento) IS tb_pessoas,
    SCOPE FOR (vitimas_atendidas) IS tb_pessoas
)
/ 

-- ALTER TYPE para corrigir o tamanho do CPF
ALTER TYPE tp_pessoa MODIFY ATTRIBUTE cpf VARCHAR2(11) CASCADE;
/
