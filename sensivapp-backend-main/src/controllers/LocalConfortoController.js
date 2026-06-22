const { LocalConforto, Tag } = require('../models');

const LocalConfortoController = {
    async criar(req, res) {
        try {
            const { nome_local, latitude, longitude, tipo_local, anotacoes, tags } = req.body;
            
            const novoLocal = await LocalConforto.create({
                id_paciente: req.id_paciente, 
                nome_local, 
                latitude, 
                longitude, 
                tipo_local, 
                anotacoes
            });

            if (tags && Array.isArray(tags)) {
                for (const nomeTag of tags) {
                    const [tag] = await Tag.findOrCreate({ 
                        where: { nome_tag: nomeTag },
                        defaults: { tipo_tag: 'geral' } 
                    });
                    await novoLocal.addTag(tag);
                }
            }

            return res.status(201).json({ 
                message: 'Local criado com sucesso!', 
                local: novoLocal 
            });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async listar(req, res) {
        try {
            const locais = await LocalConforto.findAll({ 
                where: { id_paciente: req.id_paciente },
                include: [{ model: Tag, as: 'Tags', through: { attributes: [] } }] 
            });
            return res.json(locais);
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async editar(req, res) {
        try {
            const { id } = req.params;
            const { nome_local, tipo_local, anotacoes } = req.body;
            
            const local = await LocalConforto.update(
                { nome_local, tipo_local, anotacoes },
                { where: { id_local: id, id_paciente: req.id_paciente } }
            );
            return res.json({ message: 'Local atualizado com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    },

    async deletar(req, res) {
        try {
            const { id } = req.params;
            await LocalConforto.destroy({ 
                where: { id_local: id, id_paciente: req.id_paciente } 
            });
            return res.json({ message: 'Local excluído com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: error.message });
        }
    }
};

module.exports = LocalConfortoController;