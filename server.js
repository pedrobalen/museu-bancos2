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
    try {
        const { rows } = await pool.query('SELECT id_autor, nome_autor FROM autor ORDER BY nome_autor ASC');
        res.json(rows);
    } catch (err) { res.status(500).json({ error: 'Erro ao buscar autores' }); }
});

app.get('/api/editoras', async (req, res) => {
    try {
        const { rows } = await pool.query('SELECT id_editora, nome_editora FROM editora ORDER BY nome_editora ASC');
        res.json(rows);
    } catch (err) { res.status(500).json({ error: 'Erro ao buscar editoras' }); }
});

app.get('/api/doadores', async (req, res) => {
    try {
        const { rows } = await pool.query('SELECT id_doador, nome_doador FROM doador ORDER BY nome_doador ASC');
        res.json(rows);
    } catch (err) { res.status(500).json({ error: 'Erro ao buscar doadores' }); }
});


app.post('/api/autores', async (req, res) => {
    const { nome_autor } = req.body;
    try {
        const { rows } = await pool.query('INSERT INTO autor (nome_autor) VALUES ($1) RETURNING *', [nome_autor]);
        res.status(201).json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao cadastrar autor' }); }
});

app.post('/api/editoras', async (req, res) => {
    const { nome_editora } = req.body;
    try {
        const { rows } = await pool.query('INSERT INTO editora (nome_editora) VALUES ($1) RETURNING *', [nome_editora]);
        res.status(201).json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao cadastrar editora' }); }
});

app.post('/api/doadores', async (req, res) => {
    const { nome_doador } = req.body;
    try {
        const { rows } = await pool.query('INSERT INTO doador (nome_doador) VALUES ($1) RETURNING *', [nome_doador]);
        res.status(201).json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao cadastrar doador' }); }
});


app.delete('/api/autores/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM autor WHERE id_autor = $1', [req.params.id]);
        res.json({ message: 'Autor excluído' });
    } catch (err) { 
        if (err.code === '23503') res.status(400).json({ error: 'Erro: Autor possui livros vinculados.' });
        else res.status(500).json({ error: 'Erro ao excluir autor' });
    }
});

app.delete('/api/editoras/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM editora WHERE id_editora = $1', [req.params.id]);
        res.json({ message: 'Editora excluída' });
    } catch (err) { 
        if (err.code === '23503') res.status(400).json({ error: 'Erro: Editora possui livros vinculados.' });
        else res.status(500).json({ error: 'Erro ao excluir editora' });
    }
});

app.delete('/api/doadores/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM doador WHERE id_doador = $1', [req.params.id]);
        res.json({ message: 'Doador excluído' });
    } catch (err) { 
        if (err.code === '23503') res.status(400).json({ error: 'Erro: Doador possui itens históricos vinculados.' });
        else res.status(500).json({ error: 'Erro ao excluir doador' });
    }
});


//rotas da biblioteca
app.get('/api/livros', async (req, res) => {
    const { q } = req.query;
    try {
        let query = `
            SELECT l.id_livro, l.titulo, l.ano_publicacao, l.chamada, l.assunto,
                   a.nome_autor, e.nome_editora, 
                   l.id_autor, l.id_editora
            FROM livro l
            JOIN autor a ON l.id_autor = a.id_autor
            JOIN editora e ON l.id_editora = e.id_editora
        `;
        const params = [];
        if (q) {
            query += ` WHERE l.titulo ILIKE $1 OR a.nome_autor ILIKE $1 OR l.chamada ILIKE $1 OR l.assunto ILIKE $1`;
            params.push(`%${q}%`);
        }
        query += ` ORDER BY l.titulo ASC`;
        const { rows } = await pool.query(query, params);
        res.json(rows);
    } catch (err) { res.status(500).json({ error: 'Erro ao buscar livros' }); }
});

app.post('/api/livros', async (req, res) => {
    const { titulo, id_autor, id_editora, ano_publicacao, chamada } = req.body;
    try {
        const query = `INSERT INTO livro (titulo, id_autor, id_editora, ano_publicacao, chamada) VALUES ($1, $2, $3, $4, $5) RETURNING *`;
        const { rows } = await pool.query(query, [titulo, id_autor, id_editora, ano_publicacao, chamada]);
        res.status(201).json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao salvar livro' }); }
});

app.put('/api/livros/:id', async (req, res) => {
    const { id } = req.params;
    const { titulo, ano_publicacao, chamada, id_autor, id_editora } = req.body;
    try {
        const query = `UPDATE livro SET titulo=$1, ano_publicacao=$2, chamada=$3, id_autor=$4, id_editora=$5 WHERE id_livro=$6 RETURNING *`;
        const { rows } = await pool.query(query, [titulo, ano_publicacao, chamada, id_autor, id_editora, id]);
        if (rows.length === 0) return res.status(404).json({ error: 'Livro não encontrado' });
        res.json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao atualizar livro' }); }
});

app.delete('/api/livros/:id', async (req, res) => {
    try {
        const { rowCount } = await pool.query('DELETE FROM livro WHERE id_livro = $1', [req.params.id]);
        if (rowCount === 0) return res.status(404).json({ error: 'Livro não encontrado' });
        res.json({ message: 'Livro excluído com sucesso' });
    } catch (err) { 
        if (err.code === '23503') res.status(400).json({ error: 'Não é possível excluir: existem registros dependentes.' });
        else res.status(500).json({ error: 'Erro ao excluir livro' }); 
    }
});

// rotas do acervo
app.get('/api/historico', async (req, res) => {
    const { q } = req.query;
    try {
        let query = `
            SELECT i.id_item, i.titulo, i.tipo_item, i.data_item, i.descricao, 
                   d.nome_doador, i.id_doador, i.foi_digitalizado
            FROM item_historico i
            LEFT JOIN doador d ON i.id_doador = d.id_doador
        `;
        const params = [];
        if (q) {
            query += ` WHERE i.titulo ILIKE $1 OR i.descricao ILIKE $1 OR i.tipo_item ILIKE $1 OR d.nome_doador ILIKE $1`;
            params.push(`%${q}%`);
        }
        query += ` ORDER BY i.id_item DESC`;
        const { rows } = await pool.query(query, params);
        res.json(rows);
    } catch (err) { res.status(500).json({ error: 'Erro ao buscar histórico' }); }
});

app.post('/api/historico', async (req, res) => {
    const { titulo, tipo_item, data_item, id_doador, descricao, foi_digitalizado } = req.body;
    try {
        const query = `INSERT INTO item_historico (titulo, tipo_item, data_item, id_doador, descricao, foi_digitalizado) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`;
        const values = [titulo, tipo_item, data_item, id_doador || null, descricao, foi_digitalizado];
        const { rows } = await pool.query(query, values);
        res.status(201).json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao criar item histórico' }); }
});

app.put('/api/historico/:id', async (req, res) => {
    const { id } = req.params;
    const { titulo, tipo_item, data_item, id_doador, descricao, foi_digitalizado } = req.body;
    try {
        const query = `UPDATE item_historico SET titulo=$1, tipo_item=$2, data_item=$3, id_doador=$4, descricao=$5, foi_digitalizado=$6 WHERE id_item=$7 RETURNING *`;
        const values = [titulo, tipo_item, data_item, id_doador || null, descricao, foi_digitalizado, id];
        const { rows } = await pool.query(query, values);
        if (rows.length === 0) return res.status(404).json({ error: 'Item não encontrado' });
        res.json(rows[0]);
    } catch (err) { res.status(500).json({ error: 'Erro ao atualizar item histórico' }); }
});

app.delete('/api/historico/:id', async (req, res) => {
    try {
        const { rowCount } = await pool.query('DELETE FROM item_historico WHERE id_item = $1', [req.params.id]);
        if (rowCount === 0) return res.status(404).json({ error: 'Item não encontrado' });
        res.json({ message: 'Item excluído com sucesso' });
    } catch (err) { res.status(500).json({ error: 'Erro ao excluir item' }); }
});

// Fallback
app.get(/.*/, (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
    console.log(`Rodando em http://localhost:${port}`);
});