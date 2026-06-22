const Meditacao = require('../models/Meditacao');
const FavoritoMeditacao = require('../models/FavoritoMeditacao');

const MeditacaoController = {
    // 1. Listar todas as meditações
    async listar(req, res) {
        try {
            const meditações = await Meditacao.findAll();
            return res.json(meditações);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async listarFavoritos(req, res) {
        try {
            const favoritos = await Meditacao.findAll({
                include: [{
                    model: FavoritoMeditacao,
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
            
            const [favorito, criador] = await FavoritoMeditacao.findOrCreate({
                where: { 
                    id_paciente: req.id_paciente,
                    id_meditacao: id 
                }
            });

            if (!criador) {
                return res.status(400).json({ message: 'Esta meditação já está nos seus favoritos!' });
            }

            return res.status(201).json({ message: 'Meditação favoritada com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    
    async desfavoritar(req, res) {
        try {
            const { id } = req.params;

            const deletado = await FavoritoMeditacao.destroy({
                where: {
                    id_paciente: req.id_paciente,
                    id_meditacao: id
                }
            });

            if (!deletado) {
                return res.status(444).json({ error: 'Favorito não encontrado' });
            }

            return res.json({ message: 'Meditação removida dos favoritos!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = MeditacaoController;