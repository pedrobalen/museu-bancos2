const express = require('express');
const { Pool } = require('pg');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.static('public')); 
app.use(express.json());

const pool = new Pool({
    user: 'postgres',
    host: 'localhost', 
    database: 'ArcevoBiblioteca',
    password: 'admin',
    port: 5432,
});

app.get('/api/autores', async (req, res) => {
    try { const { rows } = await pool.query('SELECT id_autor, nome_autor FROM autor ORDER BY nome_autor ASC'); res.json(rows); } catch (e) { res.status(500).json(e); }
});
app.get('/api/editoras', async (req, res) => {
    try { const { rows } = await pool.query('SELECT id_editora, nome_editora FROM editora ORDER BY nome_editora ASC'); res.json(rows); } catch (e) { res.status(500).json(e); }
});
app.get('/api/doadores', async (req, res) => {
    try { const { rows } = await pool.query('SELECT id_doador, nome_doador FROM doador ORDER BY nome_doador ASC'); res.json(rows); } catch (e) { res.status(500).json(e); }
});

app.post('/api/autores', async (req, res) => {
    try { const { rows } = await pool.query('INSERT INTO autor (nome_autor) VALUES ($1) RETURNING *', [req.body.nome_autor]); res.status(201).json(rows[0]); } catch (e) { res.status(500).json(e); }
});
app.post('/api/editoras', async (req, res) => {
    try { const { rows } = await pool.query('INSERT INTO editora (nome_editora) VALUES ($1) RETURNING *', [req.body.nome_editora]); res.status(201).json(rows[0]); } catch (e) { res.status(500).json(e); }
});
app.post('/api/doadores', async (req, res) => {
    try { const { rows } = await pool.query('INSERT INTO doador (nome_doador) VALUES ($1) RETURNING *', [req.body.nome_doador]); res.status(201).json(rows[0]); } catch (e) { res.status(500).json(e); }
});

app.delete('/api/autores/:id', async (req, res) => { try { await pool.query('DELETE FROM autor WHERE id_autor=$1', [req.params.id]); res.json({msg:'ok'}); } catch(e){ res.status(500).json(e); }});
app.delete('/api/editoras/:id', async (req, res) => { try { await pool.query('DELETE FROM editora WHERE id_editora=$1', [req.params.id]); res.json({msg:'ok'}); } catch(e){ res.status(500).json(e); }});
app.delete('/api/doadores/:id', async (req, res) => { try { await pool.query('DELETE FROM doador WHERE id_doador=$1', [req.params.id]); res.json({msg:'ok'}); } catch(e){ res.status(500).json(e); }});

//biblioteca
app.get('/api/livros', async (req, res) => {
    const { q } = req.query;
    try {
        let query = `
            SELECT l.id_livro, l.titulo, l.ano_publicacao, l.chamada, l.assunto, l.url_capa,
                   l.quantidade_total, l.quantidade_disponivel, l.quantidade_minima,
                   a.nome_autor, e.nome_editora, l.id_autor, l.id_editora
            FROM livro l
            JOIN autor a ON l.id_autor = a.id_autor
            JOIN editora e ON l.id_editora = e.id_editora
        `;
        const params = [];
        if (q) {
            query += ` WHERE l.titulo ILIKE $1 OR a.nome_autor ILIKE $1 OR l.chamada ILIKE $1`;
            params.push(`%${q}%`);
        }
        query += ` ORDER BY l.titulo ASC`;
        const { rows } = await pool.query(query, params);
        res.json(rows);
    } catch (err) { res.status(500).json({ error: 'Erro ao buscar livros' }); }
});

app.post('/api/livros', async (req, res) => {
    const { titulo, id_autor, id_editora, ano_publicacao, chamada, url_capa, quantidade_total, quantidade_minima } = req.body;
    
    const qtd = quantidade_total || 1; 
    const min = quantidade_minima || 1; 

    try {
        const query = `
            INSERT INTO livro (titulo, id_autor, id_editora, ano_publicacao, chamada, url_capa, quantidade_total, quantidade_disponivel, quantidade_minima) 
            VALUES ($1, $2, $3, $4, $5, $6, $7, $7, $8) RETURNING *`;
        const { rows } = await pool.query(query, [titulo, id_autor, id_editora, ano_publicacao, chamada, url_capa, qtd, min]);
        res.status(201).json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao salvar livro' }); }
});

app.put('/api/livros/:id', async (req, res) => {
    const { id } = req.params;
    const { titulo, ano_publicacao, chamada, id_autor, id_editora, url_capa, quantidade_total, quantidade_minima } = req.body;
    try {
        const query = `
            UPDATE livro 
            SET titulo=$1, ano_publicacao=$2, chamada=$3, id_autor=$4, id_editora=$5, url_capa=$6, quantidade_total=$7, quantidade_minima=$8 
            WHERE id_livro=$9 RETURNING *`;
        const { rows } = await pool.query(query, [titulo, ano_publicacao, chamada, id_autor, id_editora, url_capa, quantidade_total, quantidade_minima, id]);
        
        if (rows.length === 0) return res.status(404).json({ error: 'Livro não encontrado' });
        res.json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao atualizar livro' }); }
});

app.patch('/api/livros/:id/emprestar', async (req, res) => {
    const { id } = req.params;
    try {
        const query = `
            UPDATE livro 
            SET quantidade_disponivel = quantidade_disponivel - 1 
            WHERE id_livro = $1 AND quantidade_disponivel > quantidade_minima 
            RETURNING quantidade_disponivel, quantidade_minima`;
        
        const { rows, rowCount } = await pool.query(query, [id]);
        
        if (rowCount === 0) {
            const check = await pool.query('SELECT quantidade_disponivel, quantidade_minima FROM livro WHERE id_livro = $1', [id]);
            if (check.rows.length === 0) return res.status(404).json({ error: 'Livro não existe' });
            
            const livro = check.rows[0];
            if (livro.quantidade_disponivel <= livro.quantidade_minima) {
                return res.status(400).json({ error: `Limite atingido! Restam apenas ${livro.quantidade_disponivel} cópia(s) de segurança.` });
            }
            return res.status(400).json({ error: 'Erro desconhecido no estoque.' });
        }
        
        res.json({ message: 'Empréstimo registrado', novo_saldo: rows[0].quantidade_disponivel });
    } catch (err) { res.status(500).json({ error: 'Erro ao registrar empréstimo' }); }
});

app.patch('/api/livros/:id/devolver', async (req, res) => {
    const { id } = req.params;
    try {
        const query = `
            UPDATE livro 
            SET quantidade_disponivel = quantidade_disponivel + 1 
            WHERE id_livro = $1 AND quantidade_disponivel < quantidade_total 
            RETURNING quantidade_disponivel`;
        const { rows, rowCount } = await pool.query(query, [id]);
        if (rowCount === 0) return res.status(400).json({ error: 'Estoque já está cheio.' });
        res.json({ message: 'Devolução registrada', novo_saldo: rows[0].quantidade_disponivel });
    } catch (err) { res.status(500).json({ error: 'Erro ao registrar devolução' }); }
});

app.delete('/api/livros/:id', async (req, res) => {
    try { await pool.query('DELETE FROM livro WHERE id_livro=$1', [req.params.id]); res.json({msg:'ok'}); } 
    catch(e){ res.status(500).json(e); }
});

//acervo
app.get('/api/historico', async (req, res) => {
    const { q } = req.query;
    try {
        let query = `SELECT i.id_item, i.titulo, i.tipo_item, i.data_item, i.descricao, i.caminho_arquivo, d.nome_doador, i.id_doador, i.foi_digitalizado FROM item_historico i LEFT JOIN doador d ON i.id_doador = d.id_doador`;
        const params = []; if (q) { query += ` WHERE i.titulo ILIKE $1 OR i.descricao ILIKE $1`; params.push(`%${q}%`); }
        query += ` ORDER BY i.id_item DESC`; const { rows } = await pool.query(query, params); res.json(rows);
    } catch (e) { res.status(500).json(e); }
});

app.post('/api/historico', async (req, res) => {
    const { titulo, tipo_item, data_item, id_doador, descricao, foi_digitalizado, caminho_arquivo } = req.body;
    try {
        const q = `INSERT INTO item_historico (titulo, tipo_item, data_item, id_doador, descricao, foi_digitalizado, caminho_arquivo) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`;
        const { rows } = await pool.query(q, [titulo, tipo_item, data_item, id_doador || null, descricao, foi_digitalizado, caminho_arquivo]); res.status(201).json(rows[0]);
    } catch (e) { res.status(500).json(e); }
});

app.put('/api/historico/:id', async (req, res) => {
    const { id } = req.params; const { titulo, tipo_item, data_item, id_doador, descricao, foi_digitalizado, caminho_arquivo } = req.body;
    try {
        const q = `UPDATE item_historico SET titulo=$1, tipo_item=$2, data_item=$3, id_doador=$4, descricao=$5, foi_digitalizado=$6, caminho_arquivo=$7 WHERE id_item=$8 RETURNING *`;
        const { rows } = await pool.query(q, [titulo, tipo_item, data_item, id_doador || null, descricao, foi_digitalizado, caminho_arquivo, id]); res.json(rows[0]);
    } catch (e) { res.status(500).json(e); }
});

app.delete('/api/historico/:id', async (req, res) => {
    try { await pool.query('DELETE FROM item_historico WHERE id_item=$1', [req.params.id]); res.json({msg:'ok'}); } catch(e){ res.status(500).json(e); }
});

app.get(/.*/, (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.listen(port, () => console.log(`Rodando em http://localhost:${port}`)); 1