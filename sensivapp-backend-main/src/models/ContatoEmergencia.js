const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Paciente = require('./Paciente');

const ContatoEmergencia = sequelize.define('ContatoEmergencia', {
    id_contato: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    id_paciente: { type: DataTypes.INTEGER, allowNull: false },
    nome: { type: DataTypes.STRING(100), allowNull: false },
    telefone: { type: DataTypes.STRING(20), allowNull: false },
    parentesco: { type: DataTypes.STRING(50) }
}, { tableName: 'Contatos_Emergencia', timestamps: false });

Paciente.hasMany(ContatoEmergencia, { foreignKey: 'id_paciente', onDelete: 'CASCADE' });
ContatoEmergencia.belongsTo(Paciente, { foreignKey: 'id_paciente' });

module.exports = ContatoEmergencia;