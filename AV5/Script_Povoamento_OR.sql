-- Limpando as tabelas antes de popular
DELETE FROM tb_ocorrencias;
DELETE FROM tb_viaturas;
DELETE FROM tb_quarteis;
DELETE FROM tb_pessoas;
COMMIT;
/

-- Povoamento Tabela de Quarteis
INSERT INTO tb_quarteis VALUES (
    '00000000000101', 'Quartel Central de Recife',
    tp_endereco('50000000', 'Rua Principal', 'Recife', 100, 'Bloco A'),
    tp_telefone_va(
        tp_telefone('81', '32221100'),
        tp_telefone('81', '32221101')
    ),
    'Cel. Francisco Mendes'
);
/

INSERT INTO tb_quarteis VALUES (
    '00000000000202', 'Quartel Zona Norte',
    tp_endereco('50010000', 'Avenida Central', 'Recife', 250, 'Andar 2'),
    tp_telefone_va(tp_telefone('81', '34567890')),
    'Maj. Fernanda Santos'
);
/

INSERT INTO tb_quarteis VALUES (
    '00000000000303', 'Quartel de Olinda',
    tp_endereco('50020000', 'Praca da Matriz', 'Olinda', 10, NULL),
    tp_telefone_va(),
    'Cap. Roberto Junior'
);
/

INSERT INTO tb_quarteis VALUES (
    '00000000000404', 'Quartel de Jaboatão',
    tp_endereco('54000000', 'Avenida Beira Mar', 'Jaboatão dos Guararapes', 500, NULL),
    tp_telefone_va(tp_telefone('81', '35551234')),
    'Maj. Ricardo Lima'
);
/

INSERT INTO tb_quarteis VALUES (
    '00000000000505', 'Quartel de Paulista',
    tp_endereco('53400000', 'Rua da Aurora', 'Paulista', 123, 'Próximo ao Shopping'),
    tp_telefone_va(tp_telefone('81', '36667890')),
    'Cap. Joana Silva'
);
/

-- Povoamento Tabela de Pessoas -  Bombeiros
INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('11111111111', 'Ana Silva', TO_DATE('1980-01-15', 'YYYY-MM-DD'), 'A',
    'Sargento', 10, 'Chefe de Equipe',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000101'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('22222222222', 'Bruno Costa', TO_DATE('1992-05-20', 'YYYY-MM-DD'), 'A',
    'Cabo', 5, 'Motorista',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000101'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('33333333333', 'Carlos Souza', TO_DATE('1975-11-10', 'YYYY-MM-DD'), 'B',
    'Tenente', 12, 'Comandante de Pelotao',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000202'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('66666666666', 'Fernanda Goes', TO_DATE('1995-02-02', 'YYYY-MM-DD'), 'C',
    'Soldado', 2, 'Resgatista',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000404'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('77777777777', 'Gustavo Alves', TO_DATE('1982-09-18', 'YYYY-MM-DD'), 'D',
    'Cabo', 8, 'Operador de Equipamentos',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000404'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('88888888888', 'Helena Dias', TO_DATE('1970-04-30', 'YYYY-MM-DD'), 'D',
    'Sargento', 15, 'Instrutor',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000505'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('12121212121', 'Lucas Pereira', TO_DATE('1998-07-21', 'YYYY-MM-DD'), 'B',
    'Soldado', 1, 'Auxiliar',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000101'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('13131313131', 'Mariana Ferreira', TO_DATE('1985-03-14', 'YYYY-MM-DD'), 'A',
    'Cabo', 9, 'Comunicações',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000202'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('14141414141', 'Rafael Almeida', TO_DATE('1991-11-01', 'YYYY-MM-DD'), 'C',
    'Soldado', 6, 'Motorista',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000303'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('15151515151', 'Sofia Ribeiro', TO_DATE('1989-09-09', 'YYYY-MM-DD'), 'D',
    'Sargento', 11, 'Chefe de Equipe',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000404'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('16161616161', 'Thiago Martins', TO_DATE('1993-05-18', 'YYYY-MM-DD'), 'B',
    'Cabo', 4, 'Resgatista',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000505'))
);
/

INSERT INTO tb_pessoas VALUES (
    tp_bombeiro('17171717171', 'Vanessa Gonçalves', TO_DATE('1983-01-25', 'YYYY-MM-DD'), 'A',
    'Tenente', 14, 'Comandante de Pelotao',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000505'))
);
/

-- Povoamento Tabela de Pessoas - Vítimas
INSERT INTO tb_pessoas VALUES (
    tp_vitima('44444444444', 'Diana Pereira', TO_DATE('2000-03-25', 'YYYY-MM-DD'), 'B',
    'Medio', 'Pequenas escoriações')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('55555555555', 'Eduardo Lima', TO_DATE('1988-07-01', 'YYYY-MM-DD'), 'C',
    'Alto', 'Vitima inconsciente')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('99999999999', 'Igor Santos', TO_DATE('2001-12-12', 'YYYY-MM-DD'), 'A',
    'Baixo', 'Sem ferimentos aparentes')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('10000000000', 'Julia Oliveira', TO_DATE('1990-06-05', 'YYYY-MM-DD'), 'B',
    'Grave', 'Fratura exposta, hemorragia')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('18181818181', 'André Souza', TO_DATE('1978-02-11', 'YYYY-MM-DD'), NULL,
    'Medio', 'Inalação de fumaça')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('19191919191', 'Beatriz Carvalho', TO_DATE('2005-08-30', 'YYYY-MM-DD'), NULL,
    'Baixo', 'Crise de ansiedade')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('20202020202', 'Daniel Barbosa', TO_DATE('1965-06-19', 'YYYY-MM-DD'), 'C',
    'Alto', 'Parada cardiorrespiratória')
);
/

INSERT INTO tb_pessoas VALUES (
    tp_vitima('21212121212', 'Gabriela Ramos', TO_DATE('1999-04-04', 'YYYY-MM-DD'), 'B',
    'Grave', 'Queimaduras de 2º grau')
);
/

-- Povoamento Tabela de Viaturas
INSERT INTO tb_viaturas VALUES (
    'KGF1234', 'Carro de Bombeiros', 'Operacional',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000101'),
    tp_manutencao_nt(
        tp_manutencao('MANUT002', 'Corretiva', TO_DATE('2025-06-15', 'YYYY-MM-DD'), 'Reparo no sistema de freios.',
            tp_peca_trocada_nt(
                tp_peca_trocada('Pastilha de Freio'),
                tp_peca_trocada('Disco de Freio')
            )
        )
    )
);
/

INSERT INTO tb_viaturas VALUES (
    'ABC5678', 'Ambulancia', 'Em Manutencao',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000101'),
    tp_manutencao_nt()
);
/

INSERT INTO tb_viaturas VALUES (
    'XYZ9012', 'Ambulancia', 'Operacional',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000202'),
    tp_manutencao_nt()
);
/

INSERT INTO tb_viaturas VALUES (
    'GHI3456', 'Carro de Comando', 'Operacional',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000404'),
    tp_manutencao_nt()
);
/

INSERT INTO tb_viaturas VALUES (
    'LMN7890', 'Auto Bomba Tanque', 'Operacional',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000505'),
    tp_manutencao_nt(
        tp_manutencao('MANUT003', 'Preventiva', TO_DATE('2025-07-10', 'YYYY-MM-DD'), 'Revisão geral do motor.',
            tp_peca_trocada_nt(tp_peca_trocada('Filtro de Ar'))
        )
    )
);
/

INSERT INTO tb_viaturas VALUES (
    'OPQ1234', 'Ambulancia', 'Operacional',
    (SELECT REF(q) FROM tb_quarteis q WHERE q.cnpj = '00000000000505'),
    tp_manutencao_nt()
);
/

-- Povoamento Tabela de Ocorrências
INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('50000000', 'Rua Principal', 'Recife', 350, NULL),
    TO_DATE('2025-06-20', 'YYYY-MM-DD'),
    'Incendio Residencial',
    'Incendio em apartamento no 5o andar.',
    NULL,
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'KGF1234'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '11111111111'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '44444444444')
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('50010000', 'Avenida Central', 'Recife', 120, 'Fundos'),
    TO_DATE('2025-06-21', 'YYYY-MM-DD'),
    'Acidente de Transito',
    'Colisao entre carro e moto.',
    'Via interditada.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'XYZ9012'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '33333333333'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '55555555555')
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('54000000', 'Avenida Beira Mar', 'Jaboatão dos Guararapes', 880, 'Apto 301'),
    TO_DATE('2025-07-22', 'YYYY-MM-DD'),
    'Resgate de Animal',
    'Gato preso em arvore alta.',
    'Utilizado escada magirus.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'GHI3456'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '66666666666'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '99999999999')
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('53400000', 'Rua da Aurora', 'Paulista', 250, NULL),
    TO_DATE('2025-07-25', 'YYYY-MM-DD'),
    'Vazamento de Gás',
    'Forte odor de gás em prédio comercial.',
    'Área evacuada e controlada.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'LMN7890'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '88888888888'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '10000000000')
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('50020000', 'Praca da Matriz', 'Olinda', 50, 'Loja 3'),
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Atendimento Pré-Hospitalar',
    'Senhor com dor no peito em via pública.',
    'Encaminhado ao hospital mais próximo.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'OPQ1234'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '14141414141'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '20202020202')
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('50000000', 'Rua Principal', 'Recife', 1500, NULL),
    TO_DATE('2025-08-02', 'YYYY-MM-DD'),
    'Incêndio em Veículo',
    'Carro pegando fogo no acostamento.',
    'Incêndio controlado, sem vítimas.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'KGF1234'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '12121212121'),
    NULL
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('54000000', 'Avenida Beira Mar', 'Jaboatão dos Guararapes', 210, 'Barraca do Zé'),
    TO_DATE('2025-08-03', 'YYYY-MM-DD'),
    'Afogamento',
    'Banhista com dificuldades no mar.',
    'Vítima resgatada e reanimada no local.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'GHI3456'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '15151515151'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '19191919191')
);
/

INSERT INTO tb_ocorrencias VALUES (
    ocorrencia_seq.nextval,
    tp_endereco('53400000', 'Rua da Aurora', 'Paulista', 998, 'Condomínio Flores'),
    TO_DATE('2025-08-04', 'YYYY-MM-DD'),
    'Incendio Residencial',
    'Curto-circuito em apartamento.',
    'Foco de incêndio pequeno, controlado rapidamente.',
    (SELECT REF(v) FROM tb_viaturas v WHERE v.placa = 'LMN7890'),
    (SELECT TREAT(REF(p) AS REF tp_bombeiro) FROM tb_pessoas p WHERE p.cpf = '17171717171'),
    (SELECT TREAT(REF(p) AS REF tp_vitima) FROM tb_pessoas p WHERE p.cpf = '21212121212')
);
/

COMMIT;
/
