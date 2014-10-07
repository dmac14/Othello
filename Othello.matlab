%File: othello.m
%Program for my Senior Project
%Author: Daniel McDonald
%-1=First Player=Maximization
% 1=Second Player=Minimization
 
clear,clc;
 
 
%Variables FOR ALL
%Lists to keep track of various stats, initialized to zeros
minwin=zeros(1,32);     
gametie=zeros(1,32);
positioningmoves=zeros(1,32);
maxbadmove=zeros(1,32);
minsidefirst=zeros(1,32);
numberofgames=10000;
 
%begin the simulation loop, plays numberofgames for each moveswitch
for moveswitch=1:32     %point when min switches strategies
    for games=1:numberofgames
        %Variables for each game
        turn=-1;        %which player's turn it is
        notfull=1;      %flag for if the board if full
        pass=0;         %flag for if a player passes
        positioning=1;  %flag for if the simulation uses positioning or not
        move=0;         %move #
        sums=[];    
        firstbadmove=0; %flag for when the first "bad move" is made
        firstside=0;    %flag for when the first side square is taken
        maxmadebad=0;   %flag for if max player made the first "bad move"
        minsidefirstyes=0;  %flag for if the minimum player got the first side
        
        %Create board and starting positions
        Board=zeros(10,10);
        Board(5,5)=1;
        Board(6,6)=1;
        Board(5,6)=-1;
        Board(6,5)=-1;
        %disp(Board);
        
        %----------------------------------------------------------------------
        %Actual game loop
        while sum(notfull)>0
            if pass==2
                break
            end
            while pass<2
                %Variables inside of loop
                prey=turn*(-1);
                cBoard=zeros(10,10);   %Board to keep track of pieces captured for each move
                Maximum=1;
                Maximum2=1;
                Minimum=100;
                Minimum2=100;
                makemove=0;
                count=0;
                yvalue2=0;
                xvalue2=0;
                yvalue=0;
                xvalue=0;
                PossMoveY=[];
                PossMoveX=[];
                PossMoveY2=[];
                PossMoveX2=[];
                leng=1;
                leng2=1;
                d=1;
                corner=0;
                side=0;
                empty=0;
                q=1;
                flip=0;
                stratremove=0;
                movechoice=0;
                
                %Counting how many moves the minimization player has made (for switch)
                if turn==1
                    move=move+1;
                end
                
                %Searching function
                %iterates through board looking for empty squares
                %Let the hunt begin
                for y=2:9
                    for x=2:9
                        if Board(y,x)==0||Board(y,x)==2  %for empty square, look around it for opponent's piece
                            for j=-1:1
                                for i=-1:1
                                    b=y+j;
                                    a=x+i;
                                    count=0;
                                    while Board(b,a)==prey  %once found opponents piece
                                        if Board((b+j),(a+i))==turn     %if next square in same dirrection is player's piece
                                            count=count+1;              %count of how many pieces would be taken
                                            cBoard(y,x)=cBoard(y,x)+count;      %add count to square of potential move on cBoard
                                            %disp(cBoard);
                                            break
                                        elseif Board((b+j),(a+i))==prey     %if next square is opponents again, check next next square
                                            b=b+j;
                                            a=a+i;
                                            count=count+1;
                                        else
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                
                %Determine maximum/minimum number of pieces that can be
                %taken
                for y=2:9
                    for x=2:9
                        if cBoard(y,x)>Maximum
                            Maximum=cBoard(y,x);
                        end
                        if cBoard(y,x)~=0 && cBoard(y,x)<Minimum
                            Minimum=cBoard(y,x);
                        end
                    end
                end
                %disp(cBoard);

                %Switch strategies if at/past switch point
                if turn==1
                    if move>=moveswitch
                        flip=1;
                        turn=turn*-1;
                    end
                end
                
                %Making a move
                %No Positioning, just take max/min # of pieces each turn
                while positioning==0
                    %Maximization
                    if turn==-1
                        for y=2:9
                            for x=2:9
                                if cBoard(y,x)==Maximum     %go through cBoard and find squares that take the max # of pieces
                                    PossMoveY(leng)=y;      %place those squares' coords into arrays
                                    PossMoveX(leng)=x;
                                    leng=leng+1;            %array index
                                end
                            end
                        end
                    end
                    %Minimization
                    %same as above, just for minimum
                    if turn==1
                        for y=2:9
                            for x=2:9
                                if cBoard(y,x)==Minimum
                                    PossMoveY(leng)=y;
                                    PossMoveX(leng)=x;
                                    leng=leng+1;
                                end
                            end
                        end
                    end
                    %switch turn back because switched for finding moves
                    if flip==1
                        turn=turn*-1;
                    end
                    %No move?
                    if isempty(PossMoveX)==1    %if there are no moves, pass
                        pass=pass+1;
                        turn=turn*-1;
                        empty=1;
                        break
                    end
                    %randomly choose a square to make a move on
                    Randchoice=randi(leng-1,1,1);  %random integer for array index 
                    yvalue=PossMoveY(Randchoice);
                    xvalue=PossMoveX(Randchoice);
                    break
                end
                %break out of loop because player is passing
                if empty==1
                    break
                end
                
                %Positioning, try to go for sides/corners and avoid squares next to them
                leng2=1;
                while positioning==1
                    for y=2:9
                        for x=2:9
                            if cBoard(y,x)>0        %put possible move coords into arrays
                                PossMoveX(d)=x;
                                PossMoveY(d)=y;
                                d=d+1;
                            end
                        end
                    end
                    %No move?
                    if isempty(PossMoveX)==1
                        pass=pass+1;
                        turn=turn*-1;
                        empty=1;
                        break
                    end
                    %Assess Battlefield
                    for e=1
                        %Corner, loop through possible moves and see if they are in a corner
                        %if they are, that is the move to be made and flags are raised
                        while e<(length(PossMoveX)+1)
                            if PossMoveX(e)==2 && PossMoveY(e)==2
                                yvalue=PossMoveY(e);
                                xvalue=PossMoveX(e);
                                corner=1;
                                movechoice=1;
                            end
                            if PossMoveX(e)==9 && PossMoveY(e)==9
                                yvalue=PossMoveY(e);
                                xvalue=PossMoveX(e);
                                corner=1;
                                movechoice=1;
                            end
                            if PossMoveY(e)==2 && PossMoveX(e)==9
                                yvalue=PossMoveY(e);
                                xvalue=PossMoveX(e);
                                corner=1;
                                movechoice=1;
                            end
                            if PossMoveY(e)==9 && PossMoveX(e)==2
                                yvalue=PossMoveY(e);
                                xvalue=PossMoveX(e);
                                corner=1;
                                movechoice=1;
                            end
                            e=e+1;
                        end
                        %if move has been found, check to see if it follows that player's strategy, track data
                        if corner==1
                            if turn==-1
                                if cBoard(yvalue,xvalue)<Maximum
                                    positioningmoves(moveswitch)=positioningmoves(moveswitch)+1;
                                end
                            end
                            if turn==1
                                if cBoard(yvalue,xvalue)>Minimum
                                    positioningmoves(moveswitch)=positioningmoves(moveswitch)+1;
                                end
                            end
                            break
                        end
                        %No corners found
                        %Remove 3 squares around corners if said corner not taken
                        %loop through possible moves and checks if any are in the 3 squares adjacent to a corner
                        %if yes, take them out of the running
                        e=1;
                        if corner==0
                            while e<(length(PossMoveX)+1)
                                if length(PossMoveY)>1
                                    if any(PossMoveY(e)==2 && PossMoveX(e)==3 || (PossMoveY(e)==3 && PossMoveX(e)==2) || (PossMoveY(e)==3 && PossMoveX(e)==3))
                                        if Board(2,2)==0
                                            PossMoveY(e)=[];
                                            PossMoveX(e)=[];
                                            if e~=1
                                                e=e-1;
                                            end
                                        end
                                    end
                                end
                                if length(PossMoveY)>1
                                    if any(PossMoveY(e)==8 && PossMoveX(e)==2 || PossMoveY(e)==8 && PossMoveX(e)==3 || PossMoveY(e)==9 && PossMoveX(e)==3)
                                        if Board(9,2)==0
                                            PossMoveY(e)=[];
                                            PossMoveX(e)=[];
                                            if e~=1
                                                e=e-1;
                                            end
                                        end
                                    end
                                end
                                if length(PossMoveY)>1
                                    if any(PossMoveY(e)==2 && PossMoveX(e)==8 || PossMoveY(e)==3 && PossMoveX(e)==8 || PossMoveY(e)==3 && PossMoveX(e)==9)
                                        if Board(2,9)==0
                                            PossMoveY(e)=[];
                                            PossMoveX(e)=[];
                                            if e~=1
                                                e=e-1;
                                            end
                                        end
                                    end
                                end
                                if length(PossMoveY)>1
                                    if any(PossMoveY(e)==9 && PossMoveX(e)==8 || PossMoveY(e)==8 && PossMoveX(e)==8 || PossMoveY(e)==8 && PossMoveX(e)==9)
                                        if Board(9,9)==0
                                            PossMoveY(e)=[];
                                            PossMoveX(e)=[];
                                            if e~=1
                                                e=e-1;
                                            end
                                        end
                                    end
                                end
                                e=e+1;
                            end

                            %Sides
                            %Now look for possible moves on the sides of the board
                            %if any found, put them in a 2nd set of arrays of possible move coords
                            e=1;
                            while e<(length(PossMoveX)+1)
                                if any(PossMoveY(e)==2 || PossMoveY(e)==9 || PossMoveX(e)==2 || PossMoveX(e)==9)
                                    PossMoveY2(leng2)=PossMoveY(e);
                                    PossMoveX2(leng2)=PossMoveX(e);
                                    leng2=leng2+1;
                                end
                                e=e+1;
                            end
                            if isempty(PossMoveY2)==0       %if there are side moves (is empty is false)
                                while true
                                    if turn==-1
                                        for i=1:length(PossMoveY2)      %iterate through possible side moves and find maximum # of pieces to take
                                            if cBoard(PossMoveY2(i),PossMoveX2(i))>Maximum2
                                                Maximum2=cBoard(PossMoveY2(i),PossMoveX2(i));
                                            end
                                        end
                                        if length(PossMoveY2)>1
                                            if cBoard(PossMoveY2(q),PossMoveX2(q))<Maximum2     %iterate through possible moves and find which take the max
                                                PossMoveY2(q)=[];
                                                PossMoveX2(q)=[];
                                                if q~=1
                                                    q=q-1;
                                                end
                                            end
                                        end
                                    end
                                    if turn==1
                                        for i=1:length(PossMoveY2)
                                            if cBoard(PossMoveY2(i),PossMoveX2(i))<Minimum2     %find min to be taken of side moves
                                                Minimum2=cBoard(PossMoveY2(i),PossMoveX2(i));
                                            end
                                        end
                                        if length(PossMoveY2)>1
                                            if cBoard(PossMoveY2(q),PossMoveX2(q))>Minimum2     %weed out moves which dont take the min
                                                PossMoveY2(q)=[];
                                                PossMoveX2(q)=[];
                                                if q~=1
                                                    q=q-1;
                                                end
                                            end
                                        end
                                    end
                                    if (q+1)>length(PossMoveY2)
                                        break
                                    else
                                        q=q+1;
                                    end
                                end
                                %choose random move from remaining side moves
                                RandSideChoice=randi(length(PossMoveY2),1,1);
                                yvalue=PossMoveY2(RandSideChoice);
                                xvalue=PossMoveX2(RandSideChoice);
                                %raise flags
                                side=1;
                                movechoice=1;
                                %if move made doesn't follow max/min strat, track data
                                if turn==-1
                                    if cBoard(yvalue,xvalue)<Maximum
                                        positioningmoves(moveswitch)=positioningmoves(moveswitch)+1;
                                    end
                                end
                                if turn==1
                                    if cBoard(yvalue,xvalue)>Minimum
                                        positioningmoves(moveswitch)=positioningmoves(moveswitch)+1;
                                    end
                                end
                                break
                            end
                            %No corners or sides found...
                            %Removes squares next to edge if 3 squares on edge by said
                            %square are empty
                            e=1;
                            if side==0
                                %iterate through moves and find ones next to edge
                                while e<((length(PossMoveX))+1)
                                    removed=0;
                                    if PossMoveY(e)==3
                                        if PossMoveX(e)>3 && PossMoveX(e)<8
                                            if length(PossMoveX)>1
                                                if cBoard(2,PossMoveX(e)-1)==0 && cBoard(2,PossMoveX(e))==0 && cBoard(2,PossMoveX(e)+1)==0  %check to see if adjacent edge squares are empty
                                                    PossMoveY(e)=[];        % if yes, remove as possibility
                                                    PossMoveX(e)=[];
                                                    if e~=1;
                                                        e=e-1;
                                                    end
                                                    removed=1;
                                                end
                                            end
                                        end
                                    end
                                    %rinse and repeat for rest of next to edge areas
                                    if PossMoveY(e)==8
                                        if PossMoveX(e)>3 && PossMoveX(e)<8
                                            if length(PossMoveX)>1
                                                if cBoard(9,PossMoveX(e)-1)==0 && cBoard(9,PossMoveX(e))==0 && cBoard(9,PossMoveX(e)+1)==0
                                                    PossMoveY(e)=[];
                                                    PossMoveX(e)=[];
                                                    if e~=1;
                                                        e=e-1;
                                                    end
                                                    removed=1;
                                                end
                                            end
                                        end
                                    end
                                    if PossMoveX(e)==3
                                        if PossMoveY(e)>3 && PossMoveY(e)<8
                                            if length(PossMoveX)>1
                                                if cBoard(PossMoveY(e)-1,2)==0 && cBoard(PossMoveY(e),2)==0 && cBoard(PossMoveY(e)+1,2)==0
                                                    PossMoveY(e)=[];
                                                    PossMoveX(e)=[];
                                                    if e~=1;
                                                        e=e-1;
                                                    end
                                                    removed=1;
                                                end
                                            end
                                        end
                                    end
                                    if PossMoveX(e)==8
                                        if PossMoveY(e)>3 && PossMoveY(e)<8
                                            if length(PossMoveX)>1
                                                if cBoard(PossMoveY(e)-1,9)==0 && cBoard(PossMoveY(e),9)==0 && cBoard(PossMoveY(e)+1,9)==0
                                                    PossMoveY(e)=[];
                                                    PossMoveX(e)=[];
                                                    if e~=1;
                                                        e=e-1;
                                                    end
                                                    removed=1;
                                                end
                                            end
                                        end
                                    end
                                    if removed==0;
                                        e=e+1;
                                    end
                                end
                                
                                %no corner or side and undesirable squares removed
                                %Find Move not corner or side
                                while true
                                    if turn==-1
                                        if length(PossMoveY)>1
                                            if cBoard(PossMoveY(q),PossMoveX(q))<maximum    %remove moves which take below max
                                                PossMoveY(q)=[];
                                                PossMoveX(q)=[];
                                                if q~=1
                                                    q=q-1;
                                                end
                                            end
                                        end
                                    end
                                    if turn==1
                                        if length(PossMoveY)>1
                                            if cBoard(PossMoveY(q),PossMoveX(q))>minimum    %remove moves which take above min
                                                PossMoveY(q)=[];
                                                PossMoveX(q)=[];
                                                if q~=1
                                                    q=q-1;
                                                end
                                            end
                                        end
                                    end
                                    if (q+1)>length(PossMoveY)
                                        break
                                    else
                                        q=q+1;
                                    end
                                end
                            end 
                            %randomly chose move from remaining possibilities                           
                            Randchoice=randi(length(PossMoveY),1,1);
                            yvalue=PossMoveY(Randchoice);
                            xvalue=PossMoveX(Randchoice);
                            movechoice=1;
                        end
                        break
                    end
                    if empty==1
                        break
                    end
                    if flip==1
                        turn=turn*-1;
                    end
                    if movechoice==1;
                        break
                    end
                end
                if empty==1
                    break
                end

                %Making Move
                Board(yvalue,xvalue)=turn;  %puts player's piece on the board
                %disp(Board);
                %iterates through adjacent squares to find enemy pieces
                for j=-1:1
                    for i=-1:1
                        b=yvalue+j;
                        a=xvalue+i;
                        while Board(b,a)==prey      %follow trail and see if ends in player piece
                            if Board((b+j),(a+i))==turn         %if yes, about face and flip pieces to players  
                                h=j*-1;
                                g=i*-1;
                                yvalue2=b;
                                xvalue2=a;
                                makemove=1;
                            elseif Board((b+j),(a+i))==prey     %keep folowing trail
                                b=b+j;
                                a=a+i;
                            else        %if empty, break
                                break
                            end
                            while makemove==1 && Board(yvalue2,xvalue2)==prey       %actual flipping of pieces
                                Board(yvalue2,xvalue2)=turn;
                                yvalue2=yvalue2+h;
                                xvalue2=xvalue2+g;
                                pass=0;
                            end
                        end
                    end
                end
                %tests to see if certain situations have been met and then track said data
                if positioning==1
                    if firstbadmove==0
                        sums(1)=sum(Board(3,3:8));
                        sums(2)=sum(Board(8,3:8));
                        sums(3)=sum(Board(3:8,3));
                        sums(4)=sum(Board(3:8,8));
                        if any(sums)
                            sumsums=sum(sums);
                            firstbadmove=1;
                            if sumsums<0
                                maxmadebad=1;                                
                            end
                        end
                    end
                    if firstside==0
                        sums(1)=sum(Board(2,2:9));
                        sums(2)=sum(Board(9,2:9));
                        sums(3)=sum(Board(2:9,2));
                        sums(4)=sum(Board(2:9,9));
                        if any(sums)
                            sumsums=sum(sums);
                            firstside=1;
                            if sumsums>0
                                minsidefirstyes=1;                                
                            end
                        end
                    end
                end
                %disp(cBoard);
                %disp(Board);
                notfull=any(Board(2:9,2:9)==0); %check to see if any empty squares
                turn=turn*-1;
                if pass==2      %if both players have passed in a row, beak from game 
                    break
                end
            end
        end
        %disp(Board);
        winner=sum(sum(Board));     %sum up board to find winner (player are -1 and 1 respectively)
        if winner==0        %game was a tie, track data
            gametie(moveswitch)=gametie(moveswitch)+1;
        elseif winner>0         %more 1's than -1's
            minwin(moveswitch)=minwin(moveswitch)+1;
            %more data tracking
            if maxmadebad==1
                maxbadmove(moveswitch)=maxbadmove(moveswitch)+1;
            end
            if minsidefirstyes==1;
                minsidefirst(moveswitch)=minsidefirst(moveswitch)+1;
            end
        end
    end
end
minwin
positioningmoves=(positioningmoves/numberofgames);
%positioningmoves
%gametie
%write data to excel file
xlswrite('\\myhome.spu.local\users\mcdonaldd\Senior Project\MatLabExcel.xlsx',minwin,'Pos, Min 2','B3')
xlswrite('\\myhome.spu.local\users\mcdonaldd\Senior Project\MatLabExcel.xlsx',gametie,'Pos, Min 2','B4')
if positioning==1
    xlswrite('\\myhome.spu.local\users\mcdonaldd\Senior Project\MatLabExcel.xlsx',positioningmoves,'Pos, Min 2','B5')
    xlswrite('\\myhome.spu.local\users\mcdonaldd\Senior Project\MatLabExcel.xlsx',maxbadmove,'Pos, Min 2','B6')
    xlswrite('\\myhome.spu.local\users\mcdonaldd\Senior Project\MatLabExcel.xlsx',minsidefirst,'Pos, Min 2','B7')
end
%------------------------------------------------------------------------
 
 
 
 
 
 


