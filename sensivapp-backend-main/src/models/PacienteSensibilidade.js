const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const PacienteSensibilidade = sequelize.define('PacienteSensibilidade', {
    id_paciente: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        references: { model: 'Pacientes', key: 'id_usuario' }
    },
    id_tag: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        references: { model: 'Tags', key: 'id_tag' }
    }
}, {
    tableName: 'Pacientes_Sensibilidades',
    timestamps: false
});

module.exports = PacienteSensibilidade;