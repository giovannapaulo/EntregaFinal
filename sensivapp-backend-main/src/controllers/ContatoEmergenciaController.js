const ContatoEmergencia = require('../models/ContatoEmergencia'); 

const ContatoEmergenciaController = {
    async criar(req, res) {
        try {
            const { nome, telefone, parentesco } = req.body;
            const novoContato = await ContatoEmergencia.create({
                id_paciente: req.id_paciente,
                nome,
                telefone,
                parentesco
            });
            return res.status(201).json(novoContato);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async listar(req, res) {
        try {
            const contatos = await ContatoEmergencia.findAll({ 
                where: { id_paciente: req.id_paciente } 
            });
            return res.json(contatos);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async editar(req, res) {
        try {
            const { id } = req.params;
            const { nome, telefone, parentesco } = req.body;
            const atualizado = await ContatoEmergencia.update(
                { nome, telefone, parentesco },
                { where: { id_contato: id, id_paciente: req.id_paciente } }
            );
            
            if (atualizado[0] === 0) return res.status(404).json({ error: 'Contato não encontrado' });
            
            return res.json({ message: 'Contato atualizado com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async deletar(req, res) {
        try {
            const { id } = req.params;
            const deletado = await ContatoEmergencia.destroy({ 
                where: { id_contato: id, id_paciente: req.id_paciente } 
            });
            
            if (!deletado) return res.status(404).json({ error: 'Contato não encontrado' });
            
            return res.json({ message: 'Contato excluído com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = ContatoEmergenciaController;