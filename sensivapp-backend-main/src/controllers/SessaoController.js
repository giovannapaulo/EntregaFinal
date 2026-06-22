const SessaoDiarioProfissional = require('../models/SessaoDiarioProfissional');
const Acompanhamento = require('../models/Acompanhamento');

const SessaoController = {
    async listarPorVinculo(req, res) {
        try {
            const { id_vinculo } = req.params;
            const sessoes = await SessaoDiarioProfissional.findAll({
                where: { id_vinculo },
                order: [['data_sessao', 'DESC']] 
            });
            res.status(200).json(sessoes);
        } catch (error) {
            res.status(500).json({ error: "Erro ao buscar sessões" });
        }
    },

    async criarSessao(req, res) {
        try {
            const { id_vinculo, data_sessao, anotacoes_profissional, licao_de_casa } = req.body;
            const novaSessao = await SessaoDiarioProfissional.create({
                id_vinculo,
                data_sessao,
                anotacoes_profissional,
                licao_de_casa
            });
            res.status(201).json(novaSessao);
        } catch (error) {
            res.status(500).json({ error: "Erro ao registrar sessão" });
        }
    }
};

module.exports = SessaoController;