const SomRelaxante = require('../models/SomRelaxante');
const FavoritoSom = require('../models/FavoritoSom');

const SomRelaxanteController = {
    async listar(req, res) {
        try {
            const sons = await SomRelaxante.findAll();
            return res.json(sons);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async listarFavoritos(req, res) {
        try {
            const favoritos = await SomRelaxante.findAll({
                include: [{
                    model: FavoritoSom,
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
            const [favorito, criado] = await FavoritoSom.findOrCreate({
                where: { id_paciente: req.id_paciente, id_som: id }
            });

            if (!criado) return res.status(400).json({ message: 'Já está nos favoritos!' });
            return res.status(201).json({ message: 'Som favoritado!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async desfavoritar(req, res) {
        try {
            const { id } = req.params;
            const deletado = await FavoritoSom.destroy({
                where: { id_paciente: req.id_paciente, id_som: id }
            });
            if (!deletado) return res.status(404).json({ error: 'Favorito não encontrado' });
            return res.json({ message: 'Som removido dos favoritos!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = SomRelaxanteController;