const { RegistroSintoma, Tag } = require('../models');

const RegistroSintomaController = {
    async criar(req, res) {
        try {
            const { nome_sintoma, descricao, intensidade, nivel_sobrecarga, tags } = req.body;
            
            const novoRegistro = await RegistroSintoma.create({
                id_paciente: req.id_paciente,
                nome_sintoma,
                descricao,
                intensidade,
                nivel_sobrecarga 
            });

            if (tags && Array.isArray(tags)) {
                for (const nomeTag of tags) {
                    const [tag] = await Tag.findOrCreate({ 
                        where: { nome_tag: nomeTag },
                        defaults: { tipo_tag: 'sintoma' }
                    });
                    await novoRegistro.addTag(tag);
                }
            }

            return res.status(201).json({ message: 'Registro criado!', registro: novoRegistro });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async listar(req, res) {
        try {
            const registros = await RegistroSintoma.findAll({ 
                where: { id_paciente: req.id_paciente },
                include: [{ model: Tag, as: 'Tags', through: { attributes: [] } }] 
            });
            return res.json(registros);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async editar(req, res) {
        try {
            const { id } = req.params;
            const { nome_sintoma, descricao, intensidade, nivel_sobrecarga, tags } = req.body; // Adicionado aqui
            
            const registro = await RegistroSintoma.findOne({ 
                where: { id_registro: id, id_paciente: req.id_paciente } 
            });

            if (!registro) return res.status(404).json({ error: 'Registro não encontrado' });

            await registro.update({ 
                nome_sintoma, 
                descricao, 
                intensidade, 
                nivel_sobrecarga 
            });

            if (tags && Array.isArray(tags)) {
                const tagsInstancias = [];
                for (const nomeTag of tags) {
                    const [tag] = await Tag.findOrCreate({ where: { nome_tag: nomeTag }, defaults: { tipo_tag: 'sintoma' } });
                    tagsInstancias.push(tag);
                }
                await registro.setTags(tagsInstancias);
            }

            return res.json({ message: 'Registro atualizado com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async deletar(req, res) {
        try {
            const { id } = req.params;
            const deletado = await RegistroSintoma.destroy({ 
                where: { id_registro: id, id_paciente: req.id_paciente } 
            });
            
            if (!deletado) return res.status(404).json({ error: 'Registro não encontrado' });
            
            return res.json({ message: 'Registro excluído com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = RegistroSintomaController;