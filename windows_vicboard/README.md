Windows Keyboard
================

Fazendo teclado funcionar consistentemente tanto acessando o Windows diretamente
pelo Razer Blade 14 quanto pelo Macbook.

Objetivo
--------

1. Teclas especiais funcionando via `;` (ex: `;s` vira `+`)

2. Teclado numérico funcionando via `CapsLock` (ex: `CapsLock-J` vira `4`)

3. Modifiers funcionando de forma consistente

    - Right-Command = CTRL

    - Left-Command = Windows

    - CapsLock = ALT

Solução
-------

1. Instalar o teclado Vicboard no Windows

Basta abrir o `vicbrd0/setup.exe`, e aí ir nas configurações de linguagem do
Windows, achar o Vicboard lá e selecioná-lo. De preferência, ative a opção pra
poder mudar o teclado no menu de iniciar, pra quando precisar do teclado padrão.

2. Abrir o `modifiers.exe` e o `numpad.exe`

Também é possível fazer eles abrirem no StartUp, indo no Windows Explorer,
apertando `Win+R`, escrevendo: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`,
e adicionando atalhos para o `modifiers.exe` e o `numpad.exe` nesse diretório.

3. Remapear, no Razer Synapse:

- CapsLock para LeftAlt

- LeftAlt para Control

- RightAlt para F24

4. Bonus: seguir o guia do VB-Cable do Parsec

Ao usar o Parsec para conectar do Macbook pro Razer, há um problema no qual o
Razer fica mutado, e, se desmutar, ele passa a tocar o áudio também. Ou seja,
ambos os notebooks tocarão o mesmo áudio. Esse problema pode ser facilmente
resolvido instalando o aplicativo VB-Cable e seguindo o guia nesse link:
https://support.parsec.app/hc/en-us/articles/115003042152-Eliminating-Sound-Echo-While-Co-Op-ing-With-Friends
Obrigado @Geroyuni no Discord do Parsec pela solução!


Explicação
----------

O numpad.exe faz com que Alt+Teclas no Windows envie os números (`0~9`) e
brackets (`[]`) numéricos do Vicboard. Apenas com ele, o teclado numérico já
funcionará pelo Parsec, porém o Command enviará o Windows, ao invés do CTRL
(coisa do Parsec). Para consertar isso, eu adicionei um:

```
LWin::LCtrl
```

No `modifiers.ahk`. Isso faz com que o Left-Windows do Razer vire o Ctrl, e,
portanto, tudo funcionará através do Parsec. Porém, usando diretamente pelo
Razer, os modifiers ainda estarão desconfigurados: o Caps Lock funcionará como o
Caps Lock (ativando teclas maiúsculas), o Left Alt funcionará como o Left Alt (e
não como o Control) e o Right Alt funcionará como o Right Alt (e não como o
Windows). Por isso, é preciso usar o Razer Synapse da forma escrita acima.
Observe que o RightAlt precisa ser modificado para `F24`, pois, se esse fosse
modificado para `Windows`, ele iria virar um `Ctrl` por conta do "fix" que
transforma o Win do Parsec em Ctrl.

OBS: Se houver a necessidade de modificar algum `ahk`, lembrar de rebuildar os
`.exe`. Se houver a necessidade de modifiar o `klc`, lembrar de trocar a pasta
`vicbrd0` desse repositório.

Ajeitando o mouse
-----------------

O wheel do mouse fica invertido. Tentei muitas coisas, mas só o que funcionou
foi editar o registro. Explicação: https://www.windowscentral.com/how-reverse-scrolling-direction-windows-10

Path: Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID\VID_1532&PID_005E\7&8dfebf6&0&0000\Device Parameters

