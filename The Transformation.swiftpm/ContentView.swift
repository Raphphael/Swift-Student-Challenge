import SwiftUI

struct ContentView: View {
    //3x3 grid content storage
    @State var store = [[0, 0, 0], [0, 1, 2], [0, 0, 0]]
    
    //3x3 grid free play removal prompt
    let msg = ["Axe trees: ","Build back coal plant: ","Build back coal mine: ","Build back solar panels: ","Build back nuclear plant: ","Build back wind farm: ","(IRREVERSIBLE) Assign nuclear storage: ", "You can't remove a nuclear waste storage "]
    
    //3x3 grid removal prices
    let price = ["100","10000","25000","2000","100000","3000", "7500", "0"]
    
    //shop build prices
    let buildprice = ["100","5000","2500","10000","50000","10000"]
    
    //constant power production rates of the power sources
    let pow = [0.0,1.0,0.0,0.0,5.0,0.0,0.0]
    
    //3x3 border color for selection
    @State var rectColor = [[Color.black, Color.black, Color.black],[Color.black, Color.black, Color.black],[Color.black, Color.black, Color.black]]
    //3x3 border stroke thickness
    @State var rectStroke = [[2.0,2.0,2.0],[2.0,2.0,2.0],[2.0,2.0,2.0]]
    
    //shop border color
    @State var shopRectColor = [[Color.black, Color.black, Color.black],[Color.black, Color.black, Color.black],[Color.black, Color.black, Color.black]]
    
    //shop border thickness
    @State var shopRectStroke = [[2.0,2.0,2.0],[2.0,2.0,2.0],[2.0,2.0,2.0]]
    
    //tutorial step
    @State var currentStep = 0
    @State var money = 0
    @State var power = 0.0
    
    //normal animation duration
    let dur = 2.0
    
    //User selection of squares
    @State var selectedRect = [-1,-1]
    @State var shopSelectedRect = [-1,-1]
    
    //display shop
    @State var showShop = false
    
    //chose the sustainable way in tutorial
    @State var sustainable = false
    
    //sun coordinates
    let sunposx = [-200.0, 100.0, 420.0, 500.0, -340.0]
    let sunposy = [-350.0, -250.0, 100.0, 200.0, 170.0]
    
    //sky color values
    let skyr = [0.0, 0.5, 0.5, 0.0, 0.6]
    let skyg = [0.6, 0.6, 0.3, 0.0, 0.3]
    let skyb = [0.9, 0.9, 0.9, 0.3, 0.3]
    
    //ground color values
    let groundr = [0.0, 0.5, 0.3, 0.0, 0.3]
    let groundg = [0.8, 0.5, 0.5, 0.3, 0.5]
    let groundb = [0.0, 0.0, 0.4, 0.0, 0.0]
    
    //counter for animations (0 to 4)
    @State var time = 0
    
    //wind strength
    @State var windfactor = 0.0
    
    //amount of wind parks
    @State var amountWind = 0.0
    
    //amount of solar panels
    @State var amountSolar = 0.0
    
    //amount of coal plants
    @State var amountCoal = 1.0
    
    //amount of active coal mines
    @State var amountMines = 0.0
    
    //check if there is any active mine to check whether to add coal to the power grid
    @State var anyMine = 0.0
    
    //amount of nuclear plants
    @State var amountNuclear = 0.0
    
    //amount of nuclear waste storage
    @State var amountStorage = 0.0
    
    //check if there is any nuclear storage to check whether to add nuclear to the power grid
    @State var anyStorage = 0.0
    
    // for solar calculation if daytime and therefore production rate changed
    @State var daytime = 0.0
    
    //storage of usages
    @State var usdef = [140, 1, 100, 1.5, 0.0, 1, -1, 0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 ] //+3x3 coal availability from 8-16 and 3x3 nuclear capacity from 17-25
    
    //land use name
    let land = ["Forest", "Coal Plant", "Coal Mine", "Solar Panels", "Nuclear Plant", "Wind Farm", "Grassland", "Nuclear Storage"]
    
    //descriptive text of what a field can do
    let usage = ["CO2 storage capacity: ", "Current production: ", "Coal remaining: ", "Current production: ", "Current production: ","Current production: ", "", "Used capacity: "]
    
    //timer for daytime update + paycheck
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect() //Scheduled Timer didn't work, found publish: "https://developer.apple.com/documentation/combine/replacing-foundation-timers-with-timer-publishers"
    
    
    var body: some View {
        
        ZStack {
            // Sky
            Color(red: skyr[time], green: skyg[time], blue: skyb[time])
                .edgesIgnoringSafeArea(.all)
                .onReceive(timer) { input in
                    if currentStep == 9 {
                        withAnimation(.easeInOut(duration: 5.0)){
                            time = (time+1)%5 //rotating through day and night
                                    }
                                }
                            } //end of sky definition
            // Sun
            Image("TheSun")
                .resizable()
                .position(x: sunposx[time], y: sunposy[time])
                .frame(width: 100,height:100)
            
            // Grass
            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.54)
                Color(red: groundr[time], green: groundg[time], blue: groundb[time])
                            .edgesIgnoringSafeArea(.bottom)
                        } //end of grass definition
            
            // 3x3 grid of rectangles
            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.54)
                ForEach(0..<3) { i in //for didn't work in View
                       HStack {
                           ForEach(0..<3) { j in
                               Rectangle()
                                   .stroke(rectColor[i][j], lineWidth: rectStroke[i][j])
                                   .overlay(Image(String(store[i][j]))
                                       .resizable()
                                       .scaledToFit())
                                   .onTapGesture {
                                       if currentStep == 6 {
                                           if store[i][j] == 0{
                                               for k in 0...2{
                                                   for l in 0...2{
                                                       rectColor[k][l] = Color.black
                                                       rectStroke[k][l] = 2.0
                                                   }
                                               }
                                               
                                               rectStroke[i][j] = 10.0
                                               rectColor[i][j] = Color.red
                                               selectedRect = [i,j]
                                           }
                                       }
                                       if currentStep == 9 {
                                               for k in 0...2{
                                                   for l in 0...2{
                                                       rectColor[k][l] = Color.black
                                                       rectStroke[k][l] = 2.0
                                                   }
                                               }
                                               
                                               rectStroke[i][j] = 10.0
                                               rectColor[i][j] = Color.red
                                               selectedRect = [i,j]
                                           }
                                   }
                           }
                       }
                   }
                } //end of 3x3
            //shop:
            if showShop {
                  Color.white //background of shop
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.4)
                      .cornerRadius(10)
                      .offset(y: UIScreen.main.bounds.height * -0.26)
                VStack {
                    ForEach(0..<2) { i in
                           HStack {
                               ForEach(0..<3) { j in
                                   Rectangle()
                                       .stroke(shopRectColor[i][j], lineWidth: shopRectStroke[i][j])
                                       .overlay(Image(String(3*i+j+100))
                                           .resizable()
                                           .scaledToFit())
                                       .onTapGesture {
                                                   for k in 0...2{
                                                       for l in 0...2{
                                                           shopRectColor[k][l] = Color.black
                                                           shopRectStroke[k][l] = 2.0
                                                       }
                                                   }
                                                   shopRectStroke[i][j] = 10.0
                                                   shopRectColor[i][j] = Color.red
                                                   shopSelectedRect = [i,j]
                                       }
                               }
                           }
                       }
                    } .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.39)
                    .offset(y: UIScreen.main.bounds.height * -0.26)//end of 3x3
              } //end of shop definition
        } //end of ZStack

        // content overlay for game progression
        .overlay(
            Group {
                if currentStep == 0 {
                        VStack {
                            Text("THE TRANSFORMATION")
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Button("START") {
                                currentStep += 1
                                withAnimation(.easeInOut(duration: dur)) {
                                    time += 1
                                } //end of animation statement
                            } //end of Button "START"
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        } //end of VStack
                } //end of Step 0
                if currentStep == 1{
                        VStack {
                            Spacer()
                            Text("Welcome to THE TRANSFORMATION, a game where you are assigned to the difficult task to improve the power grid for a lovely community.")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            Button("Okay, let's go!"){
                                currentStep+=1
                                withAnimation(.easeInOut(duration: dur)) {
                                    time += 1
                                }//end of animation statement
                            }
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44)//end of VStack Step 1
                } //end of Step 1
                if currentStep == 2{
                    VStack{
                            Spacer()
                            Image("Ben_hello")
                                .resizable()
                                .frame(width: 300,height:300)
                                .offset(y: 50) //so that he doesn't float above the text
                            Text("Hi there, my name is Ben. I'm the power engineer here in Volt-Town. I'm happy that we found you to manage the power supply for our village, as I'm retiring. I would like to show you some basics. If you are ready we can start right away!")
                                .padding(.horizontal,10)
                                .padding(.vertical,10)
                                .background(Color.white)
                                .cornerRadius(10)
                            Button("I'm ready!")
                            {
                                currentStep+=1
                                withAnimation(.easeInOut(duration: dur)) {
                                    time += 1
                                    rectColor[1][1] = Color.red
                                    rectStroke[1][1] = 5.0
                                }//end of animation statement
                            }
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        } .padding(.bottom,UIScreen.main.bounds.height * 0.44) //end of Vstack Step 2
                }//end of Step 2
                if currentStep == 3 {
                        VStack {
                            Spacer()
                            Image("Ben_dunno")
                                .resizable()
                                .frame(width: 300,height:300)
                                .offset(y: 50)
                            Text("We've got an old coal power plant that powers our town and produces even some excess electricity that we're selling. But while providing a constant stream of electricity, it pollutes our air and we almost used all of the coal that the mine next to it provides. Now we could either extend the coal mining space or build an alternative power plant. But I'll leave that decision up to you.")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            Button("Let's go!"){
                                currentStep+=1
                                power+=1.0
                                withAnimation(.easeInOut(duration: dur)) {
                                    time += 1
                                    for i in 0...2{
                                        for j in 0...2{
                                            rectColor[i][j] = Color.red
                                            rectStroke[i][j] = 5.0
                                        }
                                    }
                                }//end of animation statement
                                
                            }
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44) //end of VStack Step 3
                } //end of Step 3
                if currentStep == 4 {
                    VStack {
                            HStack{
                                Text(String(money)+"💶")
                                    .offset(x: UIScreen.main.bounds.width * -0.4)
                                    .foregroundColor(.white)
                                Text(String(power)+" GW⚡️")
                                    .offset(x: UIScreen.main.bounds.width * 0.4)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("25000💶") //the money Ben gives us
                                .offset(x:UIScreen.main.bounds.width * 0.15,y:UIScreen.main.bounds.height * 0.15) //offset for different screen sizes
                                .foregroundColor(.white)
                            Image("Ben_hand")
                                .resizable()
                                .offset(y: 50)
                                .frame(width: 300,height:300)
                            Text("Today is your first day as the power manager! You can now see your money and the current daytime and nighttime power production at the top of the screen. You've got 9 acres of land for use. On one of them is our coal power plant, to the right of it is the coal mine, the others are forest. Feel free to do whatever you want with the land. I've saved some money for you, I'm sure that it is of good use!")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            Button("Thank you, Ben!")
                            {
                                currentStep+=1
                                money+=25000
                                power -= 1.0
                                usdef[8+5]=0 //set remaining coal at grid location 5 to 0
                                withAnimation(.easeInOut(duration: dur)) {
                                    time = 0
                                    for i in 0...2{
                                        for j in 0...2{
                                            rectColor[i][j] = Color.black
                                            rectStroke[i][j] = 2.0
                                        }
                                    }
                                }//end of animation statement
                            }
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44) //end of VStack Step 4
                } //end of Step 4
                if currentStep == 5{
                   VStack {
                            HStack{
                                Text(String(money)+"💶")
                                    .offset(x: UIScreen.main.bounds.width * -0.4)
                                    .foregroundColor(.white)
                                Text(String(power)+" GW⚡️")
                                    .offset(x: UIScreen.main.bounds.width * 0.4)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Image("Ben_thinking")
                                .resizable()
                                .frame(width: 200,height:200)
                            Text("We've run out of coal for our coal plant much sooner than expected. It's time for your first decision. Do you want to clear an acre of forest for another coal mine, or do you wish to start something more sustainable?")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            HStack{
                                Button("Clear forest"){
                                    currentStep+=1
                                    for i in 0...2{
                                        for j in 0...2{
                                            if store[i][j] == 0{
                                                rectColor[i][j] = Color.red
                                                rectStroke[i][j] = 5.0
                                            }
                                        }
                                    }
                                }//end of Button
                                .foregroundColor(.blue)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                Button("Go sustainable🌱")
                                {
                                    currentStep+=1
                                    sustainable = true
                                    usdef[1]=0 //coal plant won't produce anymore
                                }
                                .foregroundColor(.blue)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44) //end of VStack
                }//end of Step 5
                if currentStep == 6 {
                        VStack {
                            HStack{
                                Text(String(money)+"💶")
                                    .offset(x: UIScreen.main.bounds.width * -0.4)
                                    .foregroundColor(.white)
                                Text(String(power)+" GW⚡️")
                                    .offset(x: UIScreen.main.bounds.width * 0.4)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Image(sustainable ? "Ben_thumbsup" : "Ben_dunno")
                                .resizable()
                                .offset(y: 50)
                                .frame(width: 200,height:200)
                            Text(sustainable ? "Awesome! We first need to clear an acre of forest for our new power source. Choose an acre you want to clear and confirm your selection:" : "Okay. Choose an acre of forest you want to clear and confirm your selection:")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            if sustainable{
                                Button("Confirm")
                                {
                                    currentStep+=1
                                    usdef[0]-=20
                                    withAnimation(.easeInOut(duration: dur)) {
                                        store[selectedRect[0]][selectedRect[1]] = 6
                                    }//end of animation statement
                                }.foregroundColor(.blue)
                                    .padding(10)
                                    .background(selectedRect[0] == -1 ? .gray : .white) //if no rectangle selected, button shouldn't look responsive...
                                    .cornerRadius(10)
                                    .disabled(selectedRect[0] == -1) //...and be responsive
                                
                            }
                            else {
                                Button("Confirm")
                                {
                                    currentStep+=1
                                    usdef[0]-=20
                                    withAnimation(.easeInOut(duration: dur)) {
                                        store[selectedRect[0]][selectedRect[1]] = 6
                                    }//end of animation statement
                                }.foregroundColor(.blue)
                                    .padding(10)
                                    .background(selectedRect[0] == -1 ? .gray : .white)
                                    .cornerRadius(10)
                                    .disabled(selectedRect[0] == -1)}
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44)
                }//end of Step 6
                if currentStep == 7 {
                    Image("Ben_sweating")
                        .resizable()
                        .offset(x: UIScreen.main.bounds.width * -0.4)
                        .frame(width: 200,height:200)
                    Image("Shop")
                        .resizable()
                        .offset(x: UIScreen.main.bounds.width * 0.42)
                        .frame(width: 100,height:100)
                        .onTapGesture{
                            showShop.toggle()
                        }
                        VStack {
                            HStack{
                                Text(String(money)+"💶")
                                    .offset(x: UIScreen.main.bounds.width * -0.4)
                                    .foregroundColor(.white)
                                Text(String(power)+" GW⚡️")
                                    .offset(x: UIScreen.main.bounds.width * 0.4)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            if sustainable {
                                Text(showShop ? "Buy a renewable power plant by tapping on its image and hitting confirm. You can also read some information about the power sources like their amount of power produced during daytime and nighttime and about their advantages as well as their constraints. " : "And...it's gone. Now open the shop and order the construction of a new power source such as wind or solar")
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth:700)
                                Button("Confirm")
                                {
                                    store[selectedRect[0]][selectedRect[1]] = 3*shopSelectedRect[0] + shopSelectedRect[1] //save choice
                                    showShop = false
                                    if store[selectedRect[0]][selectedRect[1]] == 5{
                                        amountWind+=1 //if wind was chosen for calculation of power
                                        power+=1
                                    }
                                    if store[selectedRect[0]][selectedRect[1]] == 3{
                                        amountSolar+=1 //if solar was chosen for calculation of power
                                        power+=1.5
                                    }
                                    currentStep+=1
                                }.foregroundColor(.blue)
                                    .padding(10)
                                    .background(shopSelectedRect == [1,0]||shopSelectedRect == [1,2] ? .white : .gray)
                                    .cornerRadius(10)
                                    .disabled(shopSelectedRect != [1,0]&&shopSelectedRect != [1,2])
                                    .opacity(shopSelectedRect[0] == -1 ? 0 : 1)
                            }
                            else { //if not sustainable
                                Text(showShop ? "Buy the coal mine by tapping on the image and hitting confirm. You can also read some information about the power sources like their amount of power produced when it's sunny, cloudy or at night time and about their advantages as well as their constraints. " : "And...it's gone. Now open the shop and order the construction of a new coal mine")
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth:700)
                                Button("Confirm")
                                {
                                    store[selectedRect[0]][selectedRect[1]] = 2
                                    showShop = false
                                    power += 1.0
                                    amountMines+=1
                                    currentStep+=1
                                }.foregroundColor(.blue)
                                    .padding(10)
                                    .background(shopSelectedRect==[0,2] ? .white : .gray)
                                    .cornerRadius(10)
                                    .disabled(shopSelectedRect != [0,2])
                                    .opacity(shopSelectedRect[0] == -1 ? 0 : 1)
                            }
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44)
                } //end of Step 7
                if currentStep == 8{
                    Image("Ben_thumbsup")
                        .resizable()
                        .frame(width: 200,height:200)
                        .offset(x: UIScreen.main.bounds.width * -0.4)
                    Image("Shop")
                        .resizable()
                        .frame(width: 100,height:100)
                        .offset(x: UIScreen.main.bounds.width * 0.42)
                        .onTapGesture{
                            showShop.toggle()
                        }
                        VStack {
                            HStack{
                                Text(String(money)+"💶")
                                    .offset(x: UIScreen.main.bounds.width * -0.4)
                                    .foregroundColor(.white)
                                Text(String(power)+" GW⚡️")
                                    .offset(x: UIScreen.main.bounds.width * 0.4)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("Success! We produce power again! You are now ready to take full control over our power production. You now have access to all tools of a power manager. You can tap on an acre of land to build back existing buildings, axe trees and assign a nuclear waste storage. Please keep in mind that Volt-Town needs a capacity of 1GW during daytime and 0.5GW during nighttime. Each excess GW will be sold for 1000💶. And each missing GW costs us 1000💶. Remember, every mean of power production has its drawbacks like air pollution, night availablity, or waste storage.")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .frame(maxWidth: UIScreen.main.bounds.width*0.65)
                            Button("Let's go!")
                            {
                                showShop = false
                                currentStep+=1
                                if amountWind == 1 {
                                    power-=1 //Resetting constant factor and preparing for live generation
                                }
                            }.foregroundColor(.blue)
                                .padding(10)
                                .background(.white)
                                .cornerRadius(10)
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44)
                } //end of Step 8
                if currentStep == 9{ //free play starts here :)
                    Image("Shop")
                        .resizable()
                        .frame(width: 100,height:100)
                        .offset(x: UIScreen.main.bounds.width * 0.42)
                        .onTapGesture{
                            showShop.toggle()
                        }
                        VStack { //main (middle) Stack
                            if time < 3 { //during daytime 1 GW is needed and a sun emoji shown
                                HStack{
                                    Text(String(money)+"💶")
                                        .offset(x: UIScreen.main.bounds.width * -0.36)
                                        .foregroundColor(.white)
                                        .onReceive(timer) { input in
                                            money += Int((power-1.0)*1000.0)
                                        }
                                    Text("☀️"+String(format: "%.1f",power)+" GW/1GW⚡️") //format so that it's not 0.49999999
                                        .offset(x: UIScreen.main.bounds.width * 0.38)
                                        .foregroundColor(power>=1.0 ? .white : .red)
                                }
                            }
                            else { //during nighttime 0.5 GW is needed and a moon emoji shown
                                HStack{
                                    Text(String(money)+"💶")
                                        .offset(x: UIScreen.main.bounds.width * -0.36)
                                        .foregroundColor(.white)
                                        .onReceive(timer) { input in
                                            money += Int((power-0.5)*1000.0)
                                        }
                                    Text("🌙"+String(format: "%.1f",power)+" GW/0.5GW⚡️") //format so that it's not 0.49999999
                                        .offset(x: UIScreen.main.bounds.width * 0.38)
                                        .foregroundColor(power>=0.5 ? .white : .red)
                                }
                            }
                            if showShop == false{
                                VStack{ //air quality VStack
                                    if anyMine*amountCoal*100-usdef[0]<=0{
                                        Image("Ben_thumbsup").resizable().frame(width:100, height:100)
                                        Text("Air quality:").offset(x:0,y:-20)
                                        Text("Good").offset(x:0,y:-20)
                                    }
                                    if anyMine*amountCoal*100-usdef[0]>0 && anyMine*amountCoal*100-usdef[0]<80{
                                        Image("Ben_dunno").resizable().frame(width:100, height:100)
                                        Text("Air quality:").offset(x:0,y:-20)
                                        Text("Okay").offset(x:0,y:-20)
                                    }
                                    if anyMine*amountCoal*100-usdef[0]>=80{
                                        Image("Ben_bad").resizable().frame(width:100, height:100)
                                        Text("Air quality:").offset(x:0,y:-20)
                                        Text("Bad").offset(x:0,y:-20)
                                    }
                                }.offset(x: UIScreen.main.bounds.width * 0.42, y: UIScreen.main.bounds.height * 0.07)
                                    .foregroundColor(.white) //end of air quality VStack
                                Spacer()
                                Text(land[store[selectedRect[0]][selectedRect[1]]]) //description of Field, e.g. "Forest"
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .opacity(selectedRect[0] == -1 ? 0 : 1) //if nothing has been selected since the tutorial, no description is shown
                            
                                if store[selectedRect[0]][selectedRect[1]] == 2{
                                    Text(usage[store[selectedRect[0]][selectedRect[1]]]+String(usdef[(8+3*selectedRect[0]+selectedRect[1])])) //descriptive text + value e.g. Coal left : 100
                                        .foregroundColor(.white)
                                }
                                else if store[selectedRect[0]][selectedRect[1]] == 7{
                                    Text(usage[store[selectedRect[0]][selectedRect[1]]]+String(usdef[(17+3*selectedRect[0]+selectedRect[1])])) //descriptive text + value e.g. Storage left : 100
                                        .foregroundColor(.white)
                                }
                                else{
                                Text(store[selectedRect[0]][selectedRect[1]] == 1||store[selectedRect[0]][selectedRect[1]] == 3||store[selectedRect[0]][selectedRect[1]] == 4||store[selectedRect[0]][selectedRect[1]] == 5 ? (usage[store[selectedRect[0]][selectedRect[1]]]+String(usdef[store[selectedRect[0]][selectedRect[1]]])+" GW") : (usage[store[selectedRect[0]][selectedRect[1]]]+String(usdef[store[selectedRect[0]][selectedRect[1]]]))) //descriptive text + value e.g. Current production : 1 GW
                                    .foregroundColor(.white)
                                    .opacity(usdef[store[selectedRect[0]][selectedRect[1]]] == -1 ? 0 : 1) //if nothing has been selected since the tutorial, no descriptive text is shown
                                }
                                    
                                    if store[selectedRect[0]][selectedRect[1]] == 7 {
                                        Button(msg[store[selectedRect[0]][selectedRect[1]]]){} //Button shouldn't do anything if an irreversible nuclear storage has been planted
                                            .padding(10)
                                            .background(.gray)
                                            .cornerRadius(10)
                                    }
                                    else{ //everything else than nuclear storage
                                    Button(msg[store[selectedRect[0]][selectedRect[1]]] + price[store[selectedRect[0]][selectedRect[1]]]+"💶") //price of removing
                                    {
                                        if store[selectedRect[0]][selectedRect[1]] == 0 {
                                            usdef[0]-=20 //if forest, co2 storage reduced by 20
                                        }
                                        if store[selectedRect[0]][selectedRect[1]] == 1{
                                            amountCoal-=1
                                        }
                                        if store[selectedRect[0]][selectedRect[1]] == 2{
                                            amountMines-=1
                                        }
                                        if store[selectedRect[0]][selectedRect[1]] == 3 {
                                            amountSolar-=1
                                            if time <= 2{ //only during daytime the power needs to be reduced, at night it's already 0
                                                power-=1.5
                                            }
                                            
                                        }
                                        if store[selectedRect[0]][selectedRect[1]] == 4{
                                            amountNuclear-=1
                                        }
                                        if store[selectedRect[0]][selectedRect[1]] == 5 {
                                            amountWind-=1
                                            power-=windfactor //live power production change, so that update doesn't lag behind
                                        }
                                       
                                        money = money - Int(price[store[selectedRect[0]][selectedRect[1]]])! //if bought, remove price from bank account
                                        if store[selectedRect[0]][selectedRect[1]] == 6{
                                            store[selectedRect[0]][selectedRect[1]] = 7 //if grassland was removed, a nuclear storage is built on it
                                        }
                                        else{
                                            store[selectedRect[0]][selectedRect[1]] = 6 //else every removal leads to grassland
                                        }
                                    }.foregroundColor(.blue)
                                        .padding(10)
                                        .background(money >=  Int(price[store[selectedRect[0]][selectedRect[1]]])! ? .white : .gray)
                                        .cornerRadius(10)
                                        .disabled(money <  Int(price[store[selectedRect[0]][selectedRect[1]]])!) //you should only be able to remove something with enough money
                                        .disabled(store[selectedRect[0]][selectedRect[1]]==7) //no action on irreversible nuclear storage
                                        .opacity(shopSelectedRect[0] == -1 ? 0 : 1) //if nothing has been selected since the tutorial, no button is shown
                                }
                            }
                            else{ //in the shop:
                                Spacer()
                                if money < Int(buildprice[3*shopSelectedRect[0] + shopSelectedRect[1]])! {
                                    ZStack{
                                        Text("You don't have enough money for that.") //warning if money too small
                                            .padding(10)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                    }
                                }
                                Text(store[selectedRect[0]][selectedRect[1]] != 6 ? "You can only build on empty land! Clear what's on it first." : buildprice[3*shopSelectedRect[0] + shopSelectedRect[1]] + "💶")
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                Button("Build")
                                {
                                    store[selectedRect[0]][selectedRect[1]] = 3*shopSelectedRect[0] + shopSelectedRect[1]
                                    if store[selectedRect[0]][selectedRect[1]] == 0{
                                        usdef[0]+=20 //if forest is built, co2 storage gets bigger by 20
                                    }
                                    if store[selectedRect[0]][selectedRect[1]] == 1{
                                        amountCoal+=1
                                    }
                                    if store[selectedRect[0]][selectedRect[1]] == 2{
                                        amountMines+=1
                                    }
                                    if store[selectedRect[0]][selectedRect[1]] == 3{
                                        amountSolar+=1
                                        if time <= 2{ //only during daytime the power needs to be added, at night it should stay 0
                                            power+=1.5
                                        }
                                    }
                                    if store[selectedRect[0]][selectedRect[1]] == 4{
                                        amountNuclear+=1
                                    }
                                    if store[selectedRect[0]][selectedRect[1]] == 5{
                                        amountWind+=1
                                        power+=windfactor //live power production change, so that update doesn't lag behind
                                    }
                                    

                                    showShop = false //shop should close once transaction is done
                                    money -= Int(buildprice[3*shopSelectedRect[0] + shopSelectedRect[1]])! //buy price subtracted
                                }.foregroundColor(.blue)
                                    .padding(10)
                                    .background(store[selectedRect[0]][selectedRect[1]] == 6 && money >= Int(buildprice[3*shopSelectedRect[0] + shopSelectedRect[1]])! ? .white : .gray) //if there is grassland + you have money you're good to go!
                                    .cornerRadius(10)
                                    .disabled(store[selectedRect[0]][selectedRect[1]] != 6) //you can't build on land with something on it already
                                    .disabled(money < Int(buildprice[3*shopSelectedRect[0] + shopSelectedRect[1]])!)
                            }
                        }.padding(.bottom,UIScreen.main.bounds.height * 0.44) //end of main VStack Step 9
                    VStack{ //wind VStack
                        Image(systemName: "wind") //using SF Symbols :)
                            .resizable()
                            .frame(width:50,height:50)
                            .foregroundColor(.white)
                            .opacity(showShop ? 0 : 1)
                        Text("Wind: "+String(windfactor)).foregroundColor(.white).opacity(showShop ? 0 : 1) //contains controller for live power
                            .onReceive(timer) { input in
                                if time+1 > 3{ //+1 because it's delayed in here to the visible time
                                    daytime = 0 //change to night, so that no solar power produced
                                    usdef[3]=0 //change description of Current production to 0
                                    
                                }
                                else {
                                    daytime=1
                                    usdef[3]=1.5
                                }
                                //calculate wind:
                                windfactor = Double(Int.random(in: 2...20)) / 10.0 //to get straight numbers
                                usdef[5]=windfactor //change description of wind park to current production
                                amountMines = 0 //reset before counting mines
                                for i in 0...2 {
                                    for j in 0...2{
                                        if store[i][j] == 2 {
                                            if usdef[(8+3*i+j)] > 0{
                                                amountMines+=1 //have to count amount of Mines first over all fields
                                            }
                                        }
                                    }
                                } //end of for loop
                                for i in 0...2 {
                                    for j in 0...2{
                                        if store[i][j] == 2 {
                                            if usdef[(8+3*i+j)] > 0{
                                                usdef[(8+3*i+j)]-=1*amountCoal/amountMines //then I can subtract the needed amount from the fields that have active coal mines
                                            }
                                        }
                                    }
                                }//end of for loop
                                if amountMines >= 1{ //like a bool to check if there is any active mine
                                    anyMine = 1.0
                                }
                                else{anyMine=0.0}
                                if amountCoal >= 1.0 && amountMines >= 1.0{ //updating the current production
                                    usdef[1] = pow[1]
                                }
                                else{
                                    usdef[1] = 0
                                }
                                amountStorage = 0 //reset before counting waste storages
                                for i in 0...2 {
                                    for j in 0...2{
                                        if store[i][j] == 7 {
                                            if usdef[(17+3*i+j)] > 0{
                                                amountStorage+=1 //have to count amount of Storages first over all fields
                                            }
                                        }
                                    }
                                }//end of for loop
                                for i in 0...2 {
                                    for j in 0...2{
                                        if store[i][j] == 7 {
                                            if usdef[(17+3*i+j)] > 0{
                                                usdef[(17+3*i+j)]-=1*amountNuclear/amountStorage //then I can subtract the needed amount from the fields that have free nuclear storages
                                            }
                                        }
                                    }
                                } //end of for loop
                                if amountStorage >= 1{
                                    anyStorage = 1.0
                                }
                                else{anyStorage=0.0}
                                if amountNuclear >= 1.0 && amountStorage >= 1.0{
                                    usdef[4] = pow[4]
                                }
                                else{
                                    usdef[4] = 0
                                }
                                power = windfactor*amountWind+daytime*amountSolar*1.5+amountCoal*anyMine+5*amountNuclear*anyStorage //calculating current power production of all means
                            }//end of onReceive
                    }.offset(x: UIScreen.main.bounds.width * -0.42, y: UIScreen.main.bounds.height * -0.35) //end of Wind VStack
                } //end of Step 9
                
            } //end of Group
        ) //end of .overlay
    } //end of var body: some View
} //end of struct ContentView
