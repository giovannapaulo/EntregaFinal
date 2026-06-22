const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Acompanhamento = require('./Acompanhamento');

const SessaoDiarioProfissional = sequelize.define('SessaoDiarioProfissional', {
    id_sessao: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_vinculo: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Acompanhamento,
            key: 'id_vinculo'
        }
    },
    data_sessao: {
        type: DataTypes.DATE, 
        allowNull: false
    },
    anotacoes_profissional: {
        type: DataTypes.TEXT,
        allowNull: true
    },
    licao_de_casa: {
        type: DataTypes.TEXT,
        allowNull: true
    }
}, {
    tableName: 'Sessoes_Diario_Profissional',
    timestamps: false
});

Acompanhamento.hasMany(SessaoDiarioProfissional, { foreignKey: 'id_vinculo', onDelete: 'CASCADE' });
SessaoDiarioProfissional.belongsTo(Acompanhamento, { foreignKey: 'id_vinculo' });

module.exports = SessaoDiarioProfissional;