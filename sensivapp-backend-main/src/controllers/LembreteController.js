const Lembrete = require('../models/Lembrete');

const LembreteController = {
    async listar(req, res) {
        try {
            const lembretes = await Lembrete.findAll({ where: { id_paciente: req.id_paciente } });
            return res.json(lembretes);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async criar(req, res) {
        try {
            const { titulo, data_hora, criado_por } = req.body;
            const novoLembrete = await Lembrete.create({
                id_paciente: req.id_paciente,
                titulo,
                data_hora,
                criado_por
            });
            return res.status(201).json(novoLembrete);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async atualizar(req, res) {
        try {
            const { id } = req.params;
            await Lembrete.update(req.body, { where: { id_lembrete: id, id_paciente: req.id_paciente } });
            return res.json({ message: 'Lembrete atualizado!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async deletar(req, res) {
        try {
            const { id } = req.params;
            await Lembrete.destroy({ where: { id_lembrete: id, id_paciente: req.id_paciente } });
            return res.json({ message: 'Lembrete excluído!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = LembreteController;