#Задача 7. Робот рядом с горизонтальной бесконечно продолжающейся в обе стороны перегородкой, в котороц имеется проход шириной в одну клетку.
#Итог: Робот в клетке под проходом.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("7.jl")
#r=Robot("7.sit",animate=true)
#solve!(r)

function find_exit!(robot) #Функция поиска выходы
    side=Ost
    k=1
    i=0
       while (isborder(robot,Nord))
           along!(robot,k,side)
           i+=1
           if (i%2==1)
               side=inverse(side)
           end
            if (i%4==0)
                   k+=1
            end
       end
   end
   
   function along!(robot,num_steps,side)   
       for _i in 1:num_steps
           move!(robot,side)
       end
   end
   
   function solve!(robot)
   find_exit!(robot)
   end
   
   inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))