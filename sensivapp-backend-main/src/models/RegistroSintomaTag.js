const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const RegistroSintomaTag = sequelize.define('RegistroSintomaTag', {
    id_registro: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        references: { model: 'Registros_Sintomas', key: 'id_registro' }
    },
    id_tag: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        references: { model: 'Tags', key: 'id_tag' }
    }
}, {
    tableName: 'Registros_Sintomas_Tags',
    timestamps: false
});

module.exports = RegistroSintomaTag;