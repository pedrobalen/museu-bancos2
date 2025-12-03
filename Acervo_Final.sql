--
-- PostgreSQL database dump
--

\restrict DJDlOQySv3P5HKntWwSUUu12yKPTRHEdcgAciM6vmVJJR0PlJIGTaUF6WxBiNXA

-- Dumped from database version 17.7
-- Dumped by pg_dump version 17.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS fk_usuario_perfil;
ALTER TABLE IF EXISTS ONLY public.livro DROP CONSTRAINT IF EXISTS fk_livro_serie;
ALTER TABLE IF EXISTS ONLY public.livro DROP CONSTRAINT IF EXISTS fk_livro_local;
ALTER TABLE IF EXISTS ONLY public.livro DROP CONSTRAINT IF EXISTS fk_livro_editora;
ALTER TABLE IF EXISTS ONLY public.livro DROP CONSTRAINT IF EXISTS fk_livro_autor;
ALTER TABLE IF EXISTS ONLY public.item_historico DROP CONSTRAINT IF EXISTS fk_item_historico_doador;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_email_key;
ALTER TABLE IF EXISTS ONLY public.serie DROP CONSTRAINT IF EXISTS serie_pkey;
ALTER TABLE IF EXISTS ONLY public.perfil DROP CONSTRAINT IF EXISTS perfil_pkey;
ALTER TABLE IF EXISTS ONLY public.local_publicacao DROP CONSTRAINT IF EXISTS local_publicacao_pkey;
ALTER TABLE IF EXISTS ONLY public.livro DROP CONSTRAINT IF EXISTS livro_pkey;
ALTER TABLE IF EXISTS ONLY public.item_historico DROP CONSTRAINT IF EXISTS item_historico_pkey;
ALTER TABLE IF EXISTS ONLY public.editora DROP CONSTRAINT IF EXISTS editora_pkey;
ALTER TABLE IF EXISTS ONLY public.doador DROP CONSTRAINT IF EXISTS doador_pkey;
ALTER TABLE IF EXISTS ONLY public.autor DROP CONSTRAINT IF EXISTS autor_pkey;
ALTER TABLE IF EXISTS public.usuario ALTER COLUMN id_usuario DROP DEFAULT;
ALTER TABLE IF EXISTS public.serie ALTER COLUMN id_serie DROP DEFAULT;
ALTER TABLE IF EXISTS public.perfil ALTER COLUMN id_perfil DROP DEFAULT;
ALTER TABLE IF EXISTS public.local_publicacao ALTER COLUMN id_local DROP DEFAULT;
ALTER TABLE IF EXISTS public.livro ALTER COLUMN id_livro DROP DEFAULT;
ALTER TABLE IF EXISTS public.item_historico ALTER COLUMN id_item DROP DEFAULT;
ALTER TABLE IF EXISTS public.editora ALTER COLUMN id_editora DROP DEFAULT;
ALTER TABLE IF EXISTS public.doador ALTER COLUMN id_doador DROP DEFAULT;
ALTER TABLE IF EXISTS public.autor ALTER COLUMN id_autor DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.usuario_id_usuario_seq;
DROP TABLE IF EXISTS public.usuario;
DROP SEQUENCE IF EXISTS public.serie_id_serie_seq;
DROP TABLE IF EXISTS public.serie;
DROP SEQUENCE IF EXISTS public.perfil_id_perfil_seq;
DROP TABLE IF EXISTS public.perfil;
DROP SEQUENCE IF EXISTS public.local_publicacao_id_local_seq;
DROP TABLE IF EXISTS public.local_publicacao;
DROP SEQUENCE IF EXISTS public.livro_id_livro_seq;
DROP TABLE IF EXISTS public.livro;
DROP SEQUENCE IF EXISTS public.item_historico_id_item_seq;
DROP TABLE IF EXISTS public.item_historico;
DROP SEQUENCE IF EXISTS public.editora_id_editora_seq;
DROP TABLE IF EXISTS public.editora;
DROP SEQUENCE IF EXISTS public.doador_id_doador_seq;
DROP TABLE IF EXISTS public.doador;
DROP SEQUENCE IF EXISTS public.autor_id_autor_seq;
DROP TABLE IF EXISTS public.autor;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: autor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autor (
    id_autor integer NOT NULL,
    nome_autor character varying(250) NOT NULL
);


ALTER TABLE public.autor OWNER TO postgres;

--
-- Name: autor_id_autor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.autor_id_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.autor_id_autor_seq OWNER TO postgres;

--
-- Name: autor_id_autor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.autor_id_autor_seq OWNED BY public.autor.id_autor;


--
-- Name: doador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doador (
    id_doador integer NOT NULL,
    nome_doador character varying(200) NOT NULL
);


ALTER TABLE public.doador OWNER TO postgres;

--
-- Name: doador_id_doador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doador_id_doador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doador_id_doador_seq OWNER TO postgres;

--
-- Name: doador_id_doador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doador_id_doador_seq OWNED BY public.doador.id_doador;


--
-- Name: editora; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editora (
    id_editora integer NOT NULL,
    nome_editora character varying(150) NOT NULL
);


ALTER TABLE public.editora OWNER TO postgres;

--
-- Name: editora_id_editora_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.editora_id_editora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.editora_id_editora_seq OWNER TO postgres;

--
-- Name: editora_id_editora_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.editora_id_editora_seq OWNED BY public.editora.id_editora;


--
-- Name: item_historico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_historico (
    id_item integer NOT NULL,
    tipo_item character varying(50) NOT NULL,
    titulo character varying(400) NOT NULL,
    descricao character varying(1000),
    data_item date,
    id_doador integer,
    foi_digitalizado boolean DEFAULT false NOT NULL,
    caminho_arquivo character varying(500)
);


ALTER TABLE public.item_historico OWNER TO postgres;

--
-- Name: item_historico_id_item_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_historico_id_item_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.item_historico_id_item_seq OWNER TO postgres;

--
-- Name: item_historico_id_item_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_historico_id_item_seq OWNED BY public.item_historico.id_item;


--
-- Name: livro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.livro (
    id_livro integer NOT NULL,
    chamada character varying(80) NOT NULL,
    chamada_local character varying(90),
    id_autor integer NOT NULL,
    titulo character varying(400) NOT NULL,
    edicao character varying(250),
    id_local integer,
    id_editora integer,
    ano_publicacao smallint,
    paginas character varying(300),
    assunto character varying(697),
    id_serie integer,
    nota character varying(590),
    url_capa character varying(500),
    quantidade_total integer DEFAULT 1 NOT NULL,
    quantidade_disponivel integer DEFAULT 1 NOT NULL,
    quantidade_minima integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.livro OWNER TO postgres;

--
-- Name: livro_id_livro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.livro_id_livro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.livro_id_livro_seq OWNER TO postgres;

--
-- Name: livro_id_livro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.livro_id_livro_seq OWNED BY public.livro.id_livro;


--
-- Name: local_publicacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.local_publicacao (
    id_local integer NOT NULL,
    nome_local character varying(150) NOT NULL
);


ALTER TABLE public.local_publicacao OWNER TO postgres;

--
-- Name: local_publicacao_id_local_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.local_publicacao_id_local_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.local_publicacao_id_local_seq OWNER TO postgres;

--
-- Name: local_publicacao_id_local_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.local_publicacao_id_local_seq OWNED BY public.local_publicacao.id_local;


--
-- Name: perfil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfil (
    id_perfil integer NOT NULL,
    nome_perfil character varying(50) NOT NULL
);


ALTER TABLE public.perfil OWNER TO postgres;

--
-- Name: perfil_id_perfil_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.perfil_id_perfil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.perfil_id_perfil_seq OWNER TO postgres;

--
-- Name: perfil_id_perfil_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.perfil_id_perfil_seq OWNED BY public.perfil.id_perfil;


--
-- Name: serie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serie (
    id_serie integer NOT NULL,
    descricao_serie character varying(830) NOT NULL
);


ALTER TABLE public.serie OWNER TO postgres;

--
-- Name: serie_id_serie_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serie_id_serie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serie_id_serie_seq OWNER TO postgres;

--
-- Name: serie_id_serie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serie_id_serie_seq OWNED BY public.serie.id_serie;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nome character varying(200) NOT NULL,
    email character varying(150) NOT NULL,
    senha_hash character varying(255) NOT NULL,
    id_perfil integer NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- Name: autor id_autor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor ALTER COLUMN id_autor SET DEFAULT nextval('public.autor_id_autor_seq'::regclass);


--
-- Name: doador id_doador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doador ALTER COLUMN id_doador SET DEFAULT nextval('public.doador_id_doador_seq'::regclass);


--
-- Name: editora id_editora; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editora ALTER COLUMN id_editora SET DEFAULT nextval('public.editora_id_editora_seq'::regclass);


--
-- Name: item_historico id_item; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_historico ALTER COLUMN id_item SET DEFAULT nextval('public.item_historico_id_item_seq'::regclass);


--
-- Name: livro id_livro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro ALTER COLUMN id_livro SET DEFAULT nextval('public.livro_id_livro_seq'::regclass);


--
-- Name: local_publicacao id_local; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.local_publicacao ALTER COLUMN id_local SET DEFAULT nextval('public.local_publicacao_id_local_seq'::regclass);


--
-- Name: perfil id_perfil; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil ALTER COLUMN id_perfil SET DEFAULT nextval('public.perfil_id_perfil_seq'::regclass);


--
-- Name: serie id_serie; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie ALTER COLUMN id_serie SET DEFAULT nextval('public.serie_id_serie_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autor (id_autor, nome_autor) FROM stdin;
1	Conceição Evaristo
2	Kabengele Munanga
3	Lélia Gonzalez
4	Autor Desconhecido
\.


--
-- Data for Name: doador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doador (id_doador, nome_doador) FROM stdin;
1	Associação da Comunidade Negra de Santa Maria
2	Família Silva dos Santos
3	Coletivo de Estudantes Negros
4	Doador Anônimo
\.


--
-- Data for Name: editora; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editora (id_editora, nome_editora) FROM stdin;
1	Editora Vozes
2	Editora Pallas
3	Editora UFRGS
4	Editora UFSM
\.


--
-- Data for Name: item_historico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_historico (id_item, tipo_item, titulo, descricao, data_item, id_doador, foi_digitalizado, caminho_arquivo) FROM stdin;
5	Foto	Primeiro pao feito em santa maria	O pao	1959-06-25	4	t	https://media.istockphoto.com/id/500836350/photo/making-bread-vintage.jpg?s=612x612&w=0&k=20&c=NfiwatY-YisjgcfeBVqt8ZtR4vmXlc03jebxrDJXSLE=
\.


--
-- Data for Name: livro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.livro (id_livro, chamada, chamada_local, id_autor, titulo, edicao, id_local, id_editora, ano_publicacao, paginas, assunto, id_serie, nota, url_capa, quantidade_total, quantidade_disponivel, quantidade_minima) FROM stdin;
5	1344	\N	4	harry potter	\N	\N	2	1995	\N	\N	\N	\N	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5cAcLmelZ3JclmgtwmZinxSJr0FDIY_MzuA&s	5	4	1
6	8715	\N	4	Senhor dos Anéis	\N	\N	4	1954	\N	\N	\N	\N	https://m.media-amazon.com/images/I/81MZ8OjmQrL._AC_UF1000,1000_QL80_.jpg	5	3	1
\.


--
-- Data for Name: local_publicacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.local_publicacao (id_local, nome_local) FROM stdin;
1	São Paulo
2	Rio de Janeiro
3	Porto Alegre
4	Santa Maria
\.


--
-- Data for Name: perfil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfil (id_perfil, nome_perfil) FROM stdin;
1	ADMIN
2	PESQUISADOR
3	COMUNIDADE
4	PUBLICO
\.


--
-- Data for Name: serie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serie (id_serie, descricao_serie) FROM stdin;
1	Coleção História Afro-Brasileira
2	Série Estudos Afro-Latinos
3	Coleção Patrimônio e Memória
4	Sem Série
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, nome, email, senha_hash, id_perfil) FROM stdin;
1	Equipe Museu - Admin	admin@museu.org	hash_admin	1
2	Pesquisador João	joao.pesq@museu.org	hash_joao	2
3	Maria - Comunidade	maria.comunidade@gmail.com	hash_maria	3
4	Visitante Público	visitante@exemplo.com	hash_publico	4
\.


--
-- Name: autor_id_autor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autor_id_autor_seq', 4, true);


--
-- Name: doador_id_doador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doador_id_doador_seq', 4, true);


--
-- Name: editora_id_editora_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editora_id_editora_seq', 4, true);


--
-- Name: item_historico_id_item_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_historico_id_item_seq', 5, true);


--
-- Name: livro_id_livro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.livro_id_livro_seq', 6, true);


--
-- Name: local_publicacao_id_local_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.local_publicacao_id_local_seq', 4, true);


--
-- Name: perfil_id_perfil_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perfil_id_perfil_seq', 4, true);


--
-- Name: serie_id_serie_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serie_id_serie_seq', 4, true);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 4, true);


--
-- Name: autor autor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (id_autor);


--
-- Name: doador doador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doador
    ADD CONSTRAINT doador_pkey PRIMARY KEY (id_doador);


--
-- Name: editora editora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (id_editora);


--
-- Name: item_historico item_historico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_historico
    ADD CONSTRAINT item_historico_pkey PRIMARY KEY (id_item);


--
-- Name: livro livro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (id_livro);


--
-- Name: local_publicacao local_publicacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.local_publicacao
    ADD CONSTRAINT local_publicacao_pkey PRIMARY KEY (id_local);


--
-- Name: perfil perfil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id_perfil);


--
-- Name: serie serie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie
    ADD CONSTRAINT serie_pkey PRIMARY KEY (id_serie);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: item_historico fk_item_historico_doador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_historico
    ADD CONSTRAINT fk_item_historico_doador FOREIGN KEY (id_doador) REFERENCES public.doador(id_doador);


--
-- Name: livro fk_livro_autor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT fk_livro_autor FOREIGN KEY (id_autor) REFERENCES public.autor(id_autor);


--
-- Name: livro fk_livro_editora; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT fk_livro_editora FOREIGN KEY (id_editora) REFERENCES public.editora(id_editora);


--
-- Name: livro fk_livro_local; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT fk_livro_local FOREIGN KEY (id_local) REFERENCES public.local_publicacao(id_local);


--
-- Name: livro fk_livro_serie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT fk_livro_serie FOREIGN KEY (id_serie) REFERENCES public.serie(id_serie);


--
-- Name: usuario fk_usuario_perfil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_perfil FOREIGN KEY (id_perfil) REFERENCES public.perfil(id_perfil);


--
-- PostgreSQL database dump complete
--

\unrestrict DJDlOQySv3P5HKntWwSUUu12yKPTRHEdcgAciM6vmVJJR0PlJIGTaUF6WxBiNXA


-- 10 Queries
-- 1. Relatório que conta quantos livros e exemplares existem por Autor e Editora
SELECT a.nome_autor, e.nome_editora, COUNT(l.id_livro) as titulos, SUM(l.quantidade_total) as exemplares FROM livro l JOIN autor a ON l.id_autor = a.id_autor JOIN editora e ON l.id_editora = e.id_editora GROUP BY a.nome_autor, e.nome_editora ORDER BY exemplares DESC;

-- 2. Filtra autores que possuem mais de 2 títulos diferentes cadastrados (HAVING)
SELECT a.nome_autor, COUNT(l.id_livro) as qtd_titulos FROM livro l JOIN autor a ON l.id_autor = a.id_autor GROUP BY a.nome_autor HAVING COUNT(l.id_livro) > 2;

-- 3. Função que retorna o status textual do livro baseado no estoque
CREATE OR REPLACE FUNCTION obter_status_livro(disp INT, min INT) RETURNS TEXT AS $$ BEGIN IF disp = 0 THEN RETURN 'Esgotado'; ELSIF disp <= min THEN RETURN 'Reserva Técnica'; ELSE RETURN 'Disponível'; END IF; END; $$ LANGUAGE plpgsql;

-- 4. Trigger de Auditoria que salva cópia de livros deletados em uma tabela de log
CREATE TABLE IF NOT EXISTS log_livro_del (id SERIAL PRIMARY KEY, titulo VARCHAR(400), data_del TIMESTAMP DEFAULT NOW(), user_db VARCHAR(50));
CREATE OR REPLACE FUNCTION func_audit_del() RETURNS TRIGGER AS $$ BEGIN INSERT INTO log_livro_del (titulo, user_db) VALUES (OLD.titulo, current_user); RETURN OLD; END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg_audit_del AFTER DELETE ON livro FOR EACH ROW EXECUTE FUNCTION func_audit_del();

-- 5. Procedure para cadastrar doador verificando antes se já existe para evitar erros
CREATE OR REPLACE PROCEDURE add_doador_safe(nome VARCHAR) LANGUAGE plpgsql AS $$ BEGIN IF NOT EXISTS (SELECT 1 FROM doador WHERE nome_doador ILIKE nome) THEN INSERT INTO doador (nome_doador) VALUES (nome); END IF; END; $$;

-- 6. Busca Unificada (Union) que procura o termo 'História' tanto em livros quanto no museu
SELECT 'Livro' as tipo, titulo, assunto as info FROM livro WHERE titulo ILIKE '%História%' UNION ALL SELECT 'Museu' as tipo, titulo, descricao as info FROM item_historico WHERE titulo ILIKE '%História%';

-- 7. Trigger de Validação que impede cadastro de itens históricos com data futura
CREATE OR REPLACE FUNCTION check_data_futura() RETURNS TRIGGER AS $$ BEGIN IF NEW.data_item > CURRENT_DATE THEN RAISE EXCEPTION 'Data futura inválida'; END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg_check_data BEFORE INSERT OR UPDATE ON item_historico FOR EACH ROW EXECUTE FUNCTION check_data_futura();

-- 8. Agrupamento matemático mostrando a quantidade de itens históricos por década
SELECT (CAST(EXTRACT(YEAR FROM data_item) AS INT) / 10) * 10 || 's' AS decada, COUNT(*) FROM item_historico WHERE data_item IS NOT NULL GROUP BY decada ORDER BY decada;

-- 9. View que simplifica a consulta trazendo nomes de Autor e Editora já resolvidos
CREATE OR REPLACE VIEW view_livros_full AS SELECT l.id_livro, l.titulo, a.nome_autor, e.nome_editora, l.quantidade_disponivel FROM livro l LEFT JOIN autor a ON l.id_autor = a.id_autor LEFT JOIN editora e ON l.id_editora = e.id_editora;

-- 10. Subquery que lista os Top 5 doadores com base na contagem de itens doados
SELECT d.nome_doador, (SELECT COUNT(*) FROM item_historico i WHERE i.id_doador = d.id_doador) as total FROM doador d ORDER BY total DESC LIMIT 5;
