const sequelize = require('../config/database');

const Usuario = require('./Usuario');
const Paciente = require('./Paciente');
const Profissional = require('./Profissional');
const Acompanhamento = require('./Acompanhamento');
const SessaoDiarioProfissional = require('./SessaoDiarioProfissional');
const RegistroSintoma = require('./RegistroSintoma');
const Tag = require('./Tag');
const PacienteSensibilidade = require('./PacienteSensibilidade');
const RegistroSintomaTag = require('./RegistroSintomaTag');
const Artigo = require('./Artigo');
const SomRelaxante = require('./SomRelaxante');
const ContatoEmergencia = require('./ContatoEmergencia');
const Meditacao = require('./Meditacao');
const FavoritoArtigo = require('./FavoritoArtigo');
const FavoritoSom = require('./FavoritoSom');
const FavoritoMeditacao = require('./FavoritoMeditacao');
const LocalConforto = require('./LocalConforto');
const LocalTag = require('./LocalTag');
const Lembrete = require('./Lembrete');

Paciente.belongsToMany(Tag, { through: PacienteSensibilidade, foreignKey: 'id_paciente' });
Tag.belongsToMany(Paciente, { through: PacienteSensibilidade, foreignKey: 'id_tag' });

RegistroSintoma.belongsToMany(Tag, { through: RegistroSintomaTag, foreignKey: 'id_registro' });
Tag.belongsToMany(RegistroSintoma, { through: RegistroSintomaTag, foreignKey: 'id_tag' });

Paciente.hasMany(Lembrete, { foreignKey: 'id_paciente', onDelete: 'CASCADE' });
Lembrete.belongsTo(Paciente, { foreignKey: 'id_paciente' });

LocalConforto.belongsToMany(Tag, { through: LocalTag, foreignKey: 'id_local' });
Tag.belongsToMany(LocalConforto, { through: LocalTag, foreignKey: 'id_tag' });

Paciente.belongsToMany(Artigo, { through: FavoritoArtigo, foreignKey: 'id_paciente' });
Artigo.belongsToMany(Paciente, { through: FavoritoArtigo, foreignKey: 'id_artigo' });

Paciente.belongsToMany(SomRelaxante, { through: FavoritoSom, foreignKey: 'id_paciente' });
SomRelaxante.belongsToMany(Paciente, { through: FavoritoSom, foreignKey: 'id_som' });

Paciente.belongsToMany(Meditacao, { through: FavoritoMeditacao, foreignKey: 'id_paciente' });
Meditacao.belongsToMany(Paciente, { through: FavoritoMeditacao, foreignKey: 'id_meditacao' });

Meditacao.hasMany(FavoritoMeditacao, { foreignKey: 'id_meditacao', as: 'Favoritos' });
FavoritoMeditacao.belongsTo(Meditacao, { foreignKey: 'id_meditacao', as: 'Meditacao' });

SomRelaxante.hasMany(FavoritoSom, { foreignKey: 'id_som', as: 'Favoritos' });
FavoritoSom.belongsTo(SomRelaxante, { foreignKey: 'id_som', as: 'SomRelaxante' });

Artigo.hasMany(FavoritoArtigo, { foreignKey: 'id_artigo', as: 'Favoritos' });
FavoritoArtigo.belongsTo(Artigo, { foreignKey: 'id_artigo', as: 'Artigo' });

Paciente.hasMany(ContatoEmergencia, { foreignKey: 'id_paciente', onDelete: 'CASCADE' });
ContatoEmergencia.belongsTo(Paciente, { foreignKey: 'id_paciente' });

Paciente.hasMany(LocalConforto, { foreignKey: 'id_paciente', onDelete: 'CASCADE' });
LocalConforto.belongsTo(Paciente, { foreignKey: 'id_paciente' });

module.exports = {
    sequelize,
    Usuario,
    Paciente,
    Profissional,
    Acompanhamento,
    SessaoDiarioProfissional,
    RegistroSintoma,
    Tag,
    PacienteSensibilidade,
    RegistroSintomaTag,
    Artigo,
    SomRelaxante,
    ContatoEmergencia,
    Meditacao,
    FavoritoArtigo,
    FavoritoSom,
    FavoritoMeditacao,
    LocalConforto,
    LocalTag
};