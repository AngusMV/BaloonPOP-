local baloon
local frames={}
local activeframe
function love.load()
baloonw=75.5 -- largura do balão
 baloonh=78 -- altura do balão
  positionx, positiony=250, 250 --variável que armazena a posição do balão
   scale=1 --escala do balão
    timecontrol=400 -- variável que controla a velocidade em que um balão explode
     speedx=1 --variável que controla o movimento do balão no eixo x
      speedy=3--variável que controla o movimento do balão no eixo y 
       cooldown=0--varíavel responsável pelo cooldown entre os toques do mouse
        score=0--variável que controla o score do jogo atual
         phasecounter=1--variável responsável pela controle entre menu, jogo e tela de game over/scoreboard
          scoreboard={}--vetor que armazena os 5 maiores scores desde que o jogo foi inicializado
            for i=1,5 do
 	              scoreboard[i]=0
            end
              life=5 -- variável que armazena as vidas
--imagens/cursor
 menuwallpaper=love.graphics.newImage("images/circus2.jpg")
  gamewallpaper=love.graphics.newImage("images/clouds.jpg")
   baloon=love.graphics.newImage("images/Balloon2.png")
    cursor=love.mouse.newCursor("images/fork.png")
--músicas
 musicmenu=love.audio.newSource("audio/Stylo8Bit.mp3", stream)
  musicgame=love.audio.newSource("audio/7thElement.mp3", stream)
   musicboard=love.audio.newSource("audio/FunkyMonks.mp3", stream)
--sons do jogo
 miss=love.audio.newSource("audio/false.wav", static)
  hit=love.audio.newSource("audio/true.mp3", static)
   boom=love.audio.newSource("audio/boom.mp3", static)
--fontes
 menufont=love.graphics.newFont("font/babyblocks.ttf", 35)
  titlefont=love.graphics.newFont("font/babyblocks.ttf", 60)
   gamefont=love.graphics.newFont("font/px10.ttf", 25)
    scoreboardfont=love.graphics.newFont("font//px10.ttf", 40)
--frames
 frames[1]=love.graphics.newQuad(0, 0, baloonw, baloonh, baloon:getDimensions())
  frames[2]=love.graphics.newQuad(baloonw+7, 0, baloonw-7, baloonh, baloon:getDimensions())
   activeframe=frames[1]
    menuframe=frames[1]
end

local elapsedTime=0
function love.update(dt)
--variáveis que armazenam a posição atual do mouse, respectivamente, no eixo x e y.
 mousex=love.mouse.getX()
  mousey=love.mouse.getY()
   if phasecounter ==1 then -- dentro desta condição, está o menu
       love.audio.stop(musicboard, musicgame, boom, hit, miss)-- para as outras musicas/sons
        love.audio.play(musicmenu)-- começa a musica do menu
        if love.keyboard.isDown("z") or (love.mouse.isDown(1) and mousex >=365 and mousex <= 365+baloonw and mousey>=290 and mousey <= 290+baloonh) then -- condição para fazer o balao do menu explodir
       	    elapsedTime=elapsedTime+2*dt
             menuswitch=true --flag para poder fazer o balão do menu expandir
        end
         if menuswitch==true then-- condição para o balão expandir
        	 scale=scale+(10*elapsedTime/timecontrol)
        	  if scale>=1.4 or (love.mouse.isDown(1) and mousex >=365 and mousex <= 365+baloonw and mousey>=290 and mousey <= 290+baloonh) then -- condição para o balão explodir
               scale=1.4
                menuframe=frames[2]--o frame do balão vira o do balão estourado
        	 	     love.audio.play(boom)--barulho de estouro
                  elapsedTime=0
                   menuswitch=false
              end
         end
          if menuframe==frames[2] then -- se o balão for estourado
            elapsedTime=elapsedTime+2*dt
             scale =scale-(4*elapsedTime/timecontrol)--sua escala diminui
              if scale <= 1.15 then --chegando nesse limite
                  scale =1--escala volta ao tamanho original
                   cooldown=0--reseta o cooldown
                    menuframe=frames[1]--volta ao frame inicial
                     phasecounter=2--começa o jogo
              end
          end


   elseif phasecounter==2 then -- dentro desta condição, está o jogo
   	  -- para as musicas das outras telas
      love.audio.stop(musicmenu)
       love.audio.stop(musicboard)
        love.audio.play(musicgame)-- toca a musica do jogo
         elapsedTime=elapsedTime+2*dt
          cooldown=cooldown-1 -- diminui o cooldown do toque
        if life<=0 then -- se a vida chegar a zero, o jogo vai para a tela de game over,
          --mas antes disso, armazena-se o score no devido lugar do scoreboard
         if score >= scoreboard[1] then
           scoreboard[5]=scoreboard[4]
            scoreboard[4]=scoreboard[3]
             scoreboard[3]=scoreboard[2]
              scoreboard[2]=scoreboard[1]
               scoreboard[1]=score
               	phasecounter=3
          elseif score>=scoreboard[2] and score<scoreboard[1] then
                     scoreboard[5]=scoreboard[4]
                      scoreboard[4]=scoreboard[3]
                       scoreboard[3]=scoreboard[2]
                        scoreboard[2]=score
               	         phasecounter=3
          elseif score>=scoreboard[3] and score<scoreboard[2] then
                  scoreboard[5]=scoreboard[4]
                      scoreboard[4]=scoreboard[3]
                        scoreboard[3]=score
               	         phasecounter=3
          elseif score>=scoreboard[4] and score<scoreboard[3] then
                  scoreboard[5]=scoreboard[4]
                      scoreboard[4]=score
               	         phasecounter=3
          elseif score>=scoreboard[5] and score<scoreboard[4] then
                  scoreboard[5]=score
                   phasecounter=3
          else
          	phasecounter=3--Game over
         end
        end
        --a parte a seguir do código é responsável por controlar a velocidade em que o balão explode, de acordo com o score
      if score<50 then 
         timecontrol=400
      end      
      if score>=50 and score <100 then
         timecontrol=300 
       elseif score>=100 and score<200 then
 	     timecontrol=200
       elseif score>=200 and score<300 then
  	     timecontrol=150
       elseif score>=300 and score<350 then
 	     timecontrol=130
       elseif score>=350 and score<400 then
 	    timecontrol=110
       elseif score>=400 and score<500 then
 	    timecontrol=100
       elseif score>=500 and score<550 then
 	    timecontrol=90
       elseif score>=550 and score<600 then 
 	    timecontrol=80
       elseif score>=600 and score<650 then
 	    timecontrol=70
       elseif score>=650 and score<700 then
 	    timecontrol=60
       elseif score>=700 and score<800 then
    	timecontrol=55
       elseif score>=800 and score<900 then
 	    timecontrol=50
       elseif score>=900 and score<1000 then
 	    timecontrol=45
       elseif score>=1000 then
 	    timecontrol=40
      end

     if activeframe==frames[1] then
        scale=scale+(elapsedTime/timecontrol) -- parte do código responsável por fazer o balão expandir
          if scale>=1.4 then -- parte do código responsável por fazer o balão explodir, se chegar a um certo tamanho
         	 love.audio.stop(boom)
      	      love.audio.play(boom)--som de explosão
               elapsedTime=0
                activeframe=frames[2]--frame de balão explodido
                 life=life-1 -- menos uma vida
                  if score > 15 then 
           	         score=score-15 -- score desce em 15 pontos
      	           else 
      	        	 score=0
      	          end
           end
        if love.mouse.isDown(1) and cooldown<=0 then 
       	    cooldown=20 --o coodown reseta, para não poder spammar o botão do mouse
       	     love.audio.stop(hit, boom, miss) -- para os sons
             --parte do código responsável por checar se o toque coincide com a posição atual do balão
           if  mousex>=positionx+(speedx*elapsedTime) and mousex<=positionx+(speedx*elapsedTime)+(baloonw*scale) 
               and mousey>=positiony+(speedy*elapsedTime) and mousey<=positiony+(speedy*elapsedTime)+(baloonh*scale) then
               score=score+10 --score aumenta em 10 pontos
 		            activeframe=frames[2] --frame de balão explodido
 	               love.audio.play(hit)--som de acerto
 	                elapsedTime=0
 	                 scale=1.4 -- escala aumenta
 	             else -- se o toque for errado
 	                if score > 5 then
 	                	  score = score-5--score diminui
 	                else
 	                	  score=0
 	                end 	             
 	             	life=life-1 -- menos uma vida
 	             	love.audio.play(miss) -- som de erro
 	        end
 	    end
 else scale =scale-(5*elapsedTime/timecontrol) -- se o frame atual não for o 1, o balão diminui
      if scale <=1.25 then -- chegando nessa escala após ser explodido~:
      	 positionx=math.random(700) -- posições resetam
      	  positiony=math.random(500)
      	  speedx=math.random(-10,10)--velocidades mudam
           speedy=math.random(-1,-20)
      	    scale=1-- escala resetam
      	  activeframe=frames[1] --frame volta ao de um balão intacto
      	  elapsedTime=0--tempo reseta
      end
end
  elseif phasecounter== 3 then-- dentro desta condição está a tela de Game Over
     love.audio.stop(musicgame, hit, miss, boom)-- para os outros audios
      love.audio.play(musicboard)-- toca a musica da tela de game over
       if love.keyboard.isDown("z") then -- se o jogador tocar a tecla Z, voltamos para o jogo, e reseta-se tudo
        	  activeframe=frames[1]
             positionx, positiony=250, 250
        	    score=0
       	       life=5
       	         phasecounter=2
       	          scale=1
       	           elapsedTime=0
                    cooldown=0
       elseif love.keyboard.isDown("x") then -- se o jogador tocar a tecla X, voltamos para a tela inicial, e reseta-se tudo
       	       activeframe=frames[1]
                positionx, positiony=250, 250
              	 score=0
       	          life=5
       	           phasecounter=1
       	             scale=1
       	              elapsedTime=0
       end
end
end
function love.draw()
 if phasecounter==1 then -- na tela de menu:
  love.mouse.setCursor(cursor) -- transforma o cursor do mouse na imagem do garfo
 	 love.graphics.setColor(255, 255, 255)
 	  love.graphics.draw(menuwallpaper,0,0,0,0.45,0.6)-- desenha o wallpaper do menu
      love.graphics.setFont(menufont) -- transforma a fonte atual para a fonte do menu
       love.graphics.draw(baloon, menuframe, 365, 290, 0, scale, scale)-- desenha o balão do menu
        love.graphics.setColor(0,0,0) --seta preto como a cor das letras
         love.graphics.print("Press Z to play", 285, 480) -- escreve "pressione z para jogar" em inglês
          love.graphics.setFont(titlefont)--muda a fonte para a fonte do titulo do jogo
--escreve o titulo do jogo
           love.graphics.print("Baloon", 250, 80)
            love.graphics.print("POP", 300, 140)
 elseif phasecounter==2 then -- na tela do jogo:
  love.graphics.setColor(255, 255, 255)
   love.graphics.draw(gamewallpaper, 0, 0, 0, 0.5, 0.5)--desenha o wallpaper do jogo
    --esse segmento do codigo é responsável por desenhar os balões que representam as vidas do jogador
     if life == 5 then 
        love.graphics.draw(baloon, frames[1], 606, 7, 0, 0.5, 0.5)
         love.graphics.draw(baloon, frames[1], 642, 7, 0, 0.5, 0.5)
          love.graphics.draw(baloon, frames[1], 678, 7, 0, 0.5, 0.5)
           love.graphics.draw(baloon, frames[1], 714, 7, 0, 0.5, 0.5)
            love.graphics.draw(baloon, frames[1], 750, 7, 0, 0.5, 0.5)
     elseif life == 4 then -- uma vida se foi, um balão de vida estourou
            love.graphics.draw(baloon, frames[1], 606, 7, 0, 0.5, 0.5)
             love.graphics.draw(baloon, frames[1], 642, 7, 0, 0.5, 0.5)
              love.graphics.draw(baloon, frames[1], 678, 7, 0, 0.5, 0.5)
               love.graphics.draw(baloon, frames[1], 714, 7, 0, 0.5, 0.5)
                love.graphics.draw(baloon, frames[2], 750, 7, 0, 0.5, 0.5)
     elseif life == 3 then -- duas vidas, dois balões de vida estourados
            love.graphics.draw(baloon, frames[1], 606, 7, 0, 0.5, 0.5)
             love.graphics.draw(baloon, frames[1], 642, 7, 0, 0.5, 0.5)
              love.graphics.draw(baloon, frames[1], 678, 7, 0, 0.5, 0.5)
               love.graphics.draw(baloon, frames[2], 714, 7, 0, 0.5, 0.5)
                love.graphics.draw(baloon, frames[2], 750, 7, 0, 0.5, 0.5)
     elseif life == 2 then  -- assim por diante
            love.graphics.draw(baloon, frames[1], 606, 7, 0, 0.5, 0.5)
             love.graphics.draw(baloon, frames[1], 642, 7, 0, 0.5, 0.5)
              love.graphics.draw(baloon, frames[2], 678, 7, 0, 0.5, 0.5)
               love.graphics.draw(baloon, frames[2], 714, 7, 0, 0.5, 0.5)
                love.graphics.draw(baloon, frames[2], 750, 7, 0, 0.5, 0.5)
     elseif life == 1 then 
            love.graphics.draw(baloon, frames[1], 606, 7, 0, 0.5, 0.5)
             love.graphics.draw(baloon, frames[2], 642, 7, 0, 0.5, 0.5)
              love.graphics.draw(baloon, frames[2], 678, 7, 0, 0.5, 0.5)
               love.graphics.draw(baloon, frames[2], 714, 7, 0, 0.5, 0.5)
                 love.graphics.draw(baloon, frames[2], 750, 7, 0, 0.5, 0.5)
    end
    love.graphics.draw(baloon, activeframe, positionx+(speedx*elapsedTime), positiony+(speedy*elapsedTime), 0, scale, scale) -- desenha o balão do jogo, com posição, escala e velocidade variáveis
     love.graphics.setFont(gamefont) -- transforma a fonte atual na fonte do jogo
      love.graphics.setColor(0,0,0) -- seta preto como a cor das letras
       love.graphics.print("Score: " .. score, 20, 10)-- escreve o Score atual no canto superior esquerdo da tela
        love.graphics.print("Life: ", 550, 10)-- escreve a quantidade atual de vidas no canto superior direito da tela
         if score<=100 then
          love.graphics.print("Click on the Baloon to pop it!", 230, 550) -- escreve na tela a instrução de como jogar Baloon POP
         end
 elseif phasecounter==3 then -- na tela de game over
        love.graphics.setColor(255, 255, 255)
         love.graphics.draw(menuwallpaper,0 ,0, 0, 0.45, 0.6)--desenha o wallpaper da tela de game over
          love.graphics.setFont(titlefont)-- transforma a fonte atual na fonte de titulo
           love.graphics.setColor(0, 0, 0) -- seta preto como a cor das letras
            love.graphics.print("GAME OVER", 180, 30, 0, 0.8, 0.8) --escreve GAME OVER na tela
             love.graphics.setFont(menufont)-- transforma a  fonte atual como a mesma fonte do menu
              love.graphics.print("Press Z to Continue", 230, 430) -- indica para o jogador que deve apertar Z para continuar o jogo
               love.graphics.print("Press X to Return to Menu", 200, 500) -- indica para o jogador que deve apertar X para voltar para o menu
          --escreve na tela SCOREBOARD e mostra os 5 maiores scores, a partir de quando o jogo foi inicializado
                love.graphics.print("SCOREBOARD", 200, 100)
                 love.graphics.print("1. " ..scoreboard[1], 180, 150)
                  love.graphics.print("2. " ..scoreboard[2], 180, 200)
                   love.graphics.print("3. " ..scoreboard[3], 180, 250)
                    love.graphics.print("4. " ..scoreboard[4], 180, 300)
                     love.graphics.print("5. " ..scoreboard[5], 180, 350)
end
end