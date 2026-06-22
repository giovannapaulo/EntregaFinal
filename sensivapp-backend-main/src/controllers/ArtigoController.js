const Artigo = require('../models/Artigo');
const FavoritoArtigo = require('../models/FavoritoArtigo');

const ArtigoController = {
    async listar(req, res) {
        try {
            const artigos = await Artigo.findAll();
            return res.json(artigos);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async listarFavoritos(req, res) {
        try {
            const favoritos = await Artigo.findAll({
                include: [{
                    model: FavoritoArtigo,
                    as: 'Favoritos',
                    where: { id_paciente: req.id_paciente },
                    attributes: []
                }]
            });
            return res.json(favoritos);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async favoritar(req, res) {
        try {
            const { id } = req.params;
            const [favorito, criado] = await FavoritoArtigo.findOrCreate({
                where: { id_paciente: req.id_paciente, id_artigo: id }
            });

            if (!criado) return res.status(400).json({ message: 'Artigo já está nos favoritos!' });
            return res.status(201).json({ message: 'Artigo favoritado!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async desfavoritar(req, res) {
        try {
            const { id } = req.params;
            const deletado = await FavoritoArtigo.destroy({
                where: { id_paciente: req.id_paciente, id_artigo: id }
            });
            if (!deletado) return res.status(404).json({ error: 'Favorito não encontrado' });
            return res.json({ message: 'Artigo removido dos favoritos!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = ArtigoController;