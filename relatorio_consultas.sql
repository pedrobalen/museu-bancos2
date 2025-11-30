-- 1. Livros publicados após 2010 sobre 'História Afro-Brasileira'
SELECT l.titulo, l.ano_publicacao, a.nome_autor, l.assunto
FROM livro l
JOIN autor a ON l.id_autor = a.id_autor
WHERE l.ano_publicacao > 2010 AND l.assunto ILIKE '%História Afro-Brasileira%'
ORDER BY l.ano_publicacao DESC;

-- 2. Documentos (cartas, fotos) doados por 'Família Silva'
SELECT i.titulo, i.tipo_item, i.data_item, d.nome_doador
FROM item_historico i
JOIN doador d ON i.id_doador = d.id_doador
WHERE d.nome_doador ILIKE '%Família Silva%';

-- 3. Autor com mais livros cadastrados
SELECT a.nome_autor, COUNT(l.id_livro) as total_livros
FROM autor a
LEFT JOIN livro l ON a.id_autor = l.id_autor
GROUP BY a.nome_autor
HAVING COUNT(l.id_livro) > 0
ORDER BY total_livros DESC
LIMIT 1;

-- 4. Itens do acervo histórico não digitalizados
SELECT id_item, titulo, tipo_item, descricao 
FROM item_historico 
WHERE foi_digitalizado = false;

-- 5. Editoras com mais de 2 livros no acervo
SELECT e.nome_editora, COUNT(l.id_livro) as quantidade
FROM editora e
JOIN livro l ON e.id_editora = l.id_editora
GROUP BY e.nome_editora
HAVING COUNT(l.id_livro) > 2;

-- 6. Itens históricos em ordem cronológica (tratando datas nulas)
SELECT titulo, tipo_item, COALESCE(TO_CHAR(data_item, 'DD/MM/YYYY'), 'Data Desconhecida') as data_formatada
FROM item_historico
ORDER BY data_item ASC NULLS LAST;

-- 7. Lista unificada de títulos (Livros + Histórico) para inventário
SELECT titulo, 'Livro' as categoria, chamada as codigo_localizacao FROM livro
UNION ALL
SELECT titulo, 'Item Histórico' as categoria, 'Museu' as codigo_localizacao FROM item_historico
ORDER BY titulo;

-- 8. Itens anteriores a 1980 sem descrição detalhada
SELECT titulo, data_item 
FROM item_historico 
WHERE data_item < '1980-01-01' AND (descricao IS NULL OR length(descricao) < 5);

-- 9. Autores que também são Doadores (por nome similar)
SELECT a.nome_autor, d.nome_doador 
FROM autor a
JOIN doador d ON a.nome_autor ILIKE d.nome_doador;

-- 10. Contagem de itens por tipo e status de digitalização
SELECT tipo_item, COUNT(*) as total, SUM(CASE WHEN foi_digitalizado THEN 1 ELSE 0 END) as total_digitalizados
FROM item_historico
GROUP BY tipo_item
ORDER BY total DESC;