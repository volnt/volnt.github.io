var width = document.getElementById("game_div").offsetWidth;
var game = new Phaser.Game(width, width / 2, Phaser.AUTO, 'game_div');

game.state.add('load', load_state);
game.state.add('menu', menu_state);
game.state.add('play', play_state);
game.state.add('end', end_state);

game.state.start('load');
