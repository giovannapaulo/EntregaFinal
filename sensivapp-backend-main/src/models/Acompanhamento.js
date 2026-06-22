const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Paciente = require('./Paciente');
const Profissional = require('./Profissional');

const Acompanhamento = sequelize.define('Acompanhamento', {
    id_vinculo: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_paciente: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Paciente,
            key: 'id_usuario'
        }
    },
    id_profissional: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Profissional,
            key: 'id_usuario'
        }
    },
    clinica_local: {
        type: DataTypes.STRING(150),
        allowNull: true
    },
    data_inicio: {
        type: DataTypes.DATEONLY,
        allowNull: false
    },
    status_vinculo: {
        type: DataTypes.STRING(20),
        defaultValue: 'pendente'
    }
}, {
    tableName: 'Acompanhamentos',
    timestamps: false
});

Paciente.hasMany(Acompanhamento, { foreignKey: 'id_paciente' });
Acompanhamento.belongsTo(Paciente, { foreignKey: 'id_paciente' });

Profissional.hasMany(Acompanhamento, { foreignKey: 'id_profissional' });
Acompanhamento.belongsTo(Profissional, { foreignKey: 'id_profissional' });

module.exports = Acompanhamento;