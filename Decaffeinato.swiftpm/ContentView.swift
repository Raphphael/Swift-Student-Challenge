import SwiftUI
import AudioToolbox

struct ContentView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let buttonWidth: CGFloat = 0.05
    let buttonHeight: CGFloat = 0.075
    let buttonSpacing: CGFloat = 30
    let cornerRadius: CGFloat = 50 //OF BUTTONS AT BOTTOM
    let cornerRadiusRect: CGFloat = 20 //OF SELECTION PANES
    let strokeWidth: CGFloat = 2
    let opacity: Double = 0.9
    let overlayOpacity: Double = 0.25
    let strokeOpacity: Double = 0.2
    let fontSize: Font = .title
    let topBottomSpacing: CGFloat = 100
    let bigPanelSpacing: CGFloat = 300
    let mainViewHeight: CGFloat = 0.5
    let mainViewWidthOffset: CGFloat = 1010
    let animationDuration: CGFloat = 0.2
    let musicPlayer = BackgroundMusicPlayer()
    
   @State var currentCaffeine: Int = 0
    
    @State private var mainScreenVisible = true
    @State private var addScreenVisible = false
    @State private var settingsScreenVisible = false
    @State private var dataScreenVisible = false
    
    @State private var searchText = ""
    @State private var filteredBeverages: [String] = []
    @State private var americanoSelected = false
    @State private var cokeSelected = false
    @State private var cappSelected = false
    @State private var latteSelected = false
    @State private var backgroundSelection = "background_coffeeshop"
    @State private var sizeOption = ""
    @State private var drinkName = ""
    @State private var time = Date()
    @State private var showCustomSelection = false
    
    @State private var height: CGFloat = 300
    
    @State private var triviaSection = 0
    @State private var triviaAnswer = [
        "",
        "Alright, let's start with the first question:",
    "Correct! Caffeine has a half-life of around 4 hours. That means that it takes around 4 hours for your body to get rid of half of the caffeine you drank.",
    "That's right! Scientists recommend to stop drinking caffeinated coffee at least 8 yours before sleep. But there is an alternative...",
    "Exactly! Coffee is very good for your health, so if you feel like drinking coffee late, just opt for a Decaf/Decaffeinato! It lowers probabilities of many health problems.",
    "Correct! Coffee has been shown to lower the risk of Alzheimers and heart failure, while having a positive effect on mood! Okay, last trivia question for you:",
    "With about 29% of the global production, Brazil is the clear leader of coffee production. Thank you for playing, I hope you learned that while coffee is good for your health in many aspects, its caffeine can harm your sleep. So, next time you want do drink a coffee late in the day, maybe opt for a Decaffeinato! Beanley out!"]
    @State private var triviaQuestion = [
        "Welcome to the caffeine trivia!", 
        "What happens to the caffeine level in your body after approximately 4 hours?",
    "How long before bed should you stop consuming caffeinated drinks to avoid negative effects on your sleep?",
        "What should you order if you want to drink a coffee but it's already late afternoon?",
        "Which health indicator is NOT lowered by coffee?",
        "What country is the top producer of coffee?",
        "End of Trivia Quiz"
    ]
    @State private var triviaChoice:  [(String, String, String)] = [
        ("","",""),
        ("It's cleared out","It is halved", "It starts to work"),
        ("30 minutes", "3 hours", "8 hours"),
        ("Decaf", "Doppio", "Extra Shot"),
        ("Happiness","Alzheimers risk", "Heart failure risk"),
        ("Switzerland", "Brazil", "USA"),
        ("➡️","Restart","⬅️")
    ]
    @State private var triviaCorrect = [
        (false, false, false), 
        (false, true, false),
    (false, false, true),
    (true, false, false),
    (true, false, false),
     (false, true, false),
    (false, true, false)]
    @State private var triviaWrongButtonPressed = [
        (false, false, false),
        (false, false, false),
        (false, false, false),
        (false, false, false),
        (false, false, false),
        (false, false, false),
        (false, false, false)
    ]
    
    @State var tupleArray: [(String, Int, Date)] = [
    ]
    func resetAll() {
        mainScreenVisible = true
        dataScreenVisible = false
        settingsScreenVisible = false
        addScreenVisible = false
        americanoSelected = false
        cokeSelected = false
        cappSelected = false
        latteSelected = false
        searchText = ""
        sizeOption = ""
        drinkName = ""
        showCustomSelection = false
        height = 300
    }
    func calculateCaffeineContent() -> Int {
        var totalCaffeine: Double = 0
        let now = Date()
        for (name, caffeine, date) in tupleArray {
            let timeElapsed = now.timeIntervalSince(date)
            let hoursElapsed = timeElapsed / 3600
            if hoursElapsed < 12 {
                let weight = pow(0.5, hoursElapsed / 4)
                totalCaffeine += Double(caffeine) * weight
            }
        }
        // Remove entries older than 12 hours
        tupleArray.removeAll { now.timeIntervalSince($0.2) > 43200 }
        return Int(totalCaffeine)
    }

    
    var body: some View {
        
        ZStack {
            Image(backgroundSelection)
                .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    musicPlayer.playBackgroundMusic(backgroundSelection: backgroundSelection)
                }
            VStack {
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                        .overlay(Color.white.opacity(overlayOpacity))
                        .cornerRadius(cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.white.opacity(strokeOpacity), lineWidth: strokeWidth)
                        )
                        .opacity(opacity)
                        .frame(width: (addScreenVisible || settingsScreenVisible || dataScreenVisible) ? (screenWidth - mainViewWidthOffset) * 1.1 : screenWidth - mainViewWidthOffset,
                               height: screenHeight * mainViewHeight)
                        .animation(.easeInOut(duration: 0.3), value: addScreenVisible)
                        .animation(.easeInOut(duration: 0.3), value: settingsScreenVisible)
                        .animation(.easeInOut(duration: 0.3), value: dataScreenVisible)

                    if(mainScreenVisible){
                        VStack {
                            if(currentCaffeine == 0){
                                VStack{
                                    Image("Cappuccino").resizable()
                                        .frame(width: screenWidth * buttonWidth * 2.5,
                                               height: screenHeight * buttonHeight * 2.5)
                                        .cornerRadius(20)
                                    Text("Welcome to Decaffeinato!")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white) 
                                    Text("")
                                    Text("We all love caffeine! But it can impact our sleep.")
                                    .foregroundColor(.white) 
                                    Text("That's why scientists recommend limiting")
                                    .foregroundColor(.white) 
                                    Text("caffeine intake in the second half of the day.")
                                    .foregroundColor(.white) 
                                    Text("It takes around 4 hours for the body to halve")
                                    .foregroundColor(.white) 
                                    Text("the caffeine content in your blood.")
                                    .foregroundColor(.white) 
                                    Text("")
                                    Text("This app helps keeping track of that.")
                                    .bold()
                                    .foregroundColor(.white) 
                                    Text("Tap the + button below to add your first drink:").bold()
                                    .foregroundColor(.white) 
                                    Text("")
                                }
                            }
                            else{
                                Text("Current Caffeine Level:")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("\(currentCaffeine) mg")
                                    .font(.system(size: CGFloat(currentCaffeine)*0.1 + 32, weight: .black))
                                    .foregroundColor(.white)
                                
                                GraphView(currentCaffeine: Double(currentCaffeine))
                                    .frame(height: 150)
                                    .padding(.horizontal, 330)
                                    .padding(.top, 10)
                                
                                Spacer().frame(height: 50)
                                
                                Text("☕️ Your caffeinated drinks in the past 12 hours: ☕️")
                                .foregroundColor(.white)
                                 Text(tupleArray.map { $0.0 }.joined(separator: ", "))
                                    .frame(width: 350)
                            }
                        }
                    }
                    if(addScreenVisible){
                        VStack {
                            if showCustomSelection {
                                ZStack {
                                    FrostyGlass()
                                        .frame(width: 400, height: height)
                                    VStack{
                                        Text("Select Drink Size")
                                            .bold()
                                            .font(.system(size: 32, weight: .bold))
                                        Image("notStarbucks")
                                            .resizable()
                                            .frame(width: screenWidth * buttonWidth * 2.5,
                                                   height: screenHeight * buttonHeight * 2.5)
                                            .cornerRadius(20)
                                        Text(sizeOption + drinkName)
                                        let beverageManager = BeverageManager.shared
                                        let availableSizes = beverageManager.getAvailableSizes(for: drinkName)
                                        if(sizeOption.isEmpty){
                                            HStack {
                                                ForEach(availableSizes, id: \.self) { size in
                                                    Button(action: {
                                                        sizeOption = size
                                                    }) {
                                                        Text(size)
                                                            .padding()
                                                            .background(Color.gray)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                            }
                                        }
                                        else{
                                            HStack{
                                                DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                                    .datePickerStyle(CompactDatePickerStyle())
                                                    .scaleEffect(1.5)
                                                    .offset(x:-310)
                                                
                                                Button(action: {
                                                    let newElement: (String, Int, Date) = (sizeOption + drinkName, BeverageManager.shared.getCaffeineContent(for: drinkName, size: sizeOption), time)
                                                    print(newElement)
                                                    tupleArray.append(newElement)
                                                    resetAll()
                                                    currentCaffeine = calculateCaffeineContent()
                                                }){
                                                    Image(systemName: "checkmark")
                                                        .padding(16)
                                                        .background(Color.gray)
                                                        .cornerRadius(50)
                                                        .shadow(radius: 2)
                                                }
                                            } 
                                            .offset(x:-350)
                                        }
                                    }
                                    
                                }
                                .animation(.easeInOut(duration: 0.3), value: height)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        height = 400
                                    }
                                }
                            }
                            if(!americanoSelected && !cokeSelected && !cappSelected && !latteSelected && drinkName.isEmpty){
                                HStack{
                                    if(searchText.isEmpty){
                                        Text("Add A Drink")
                                            .bold()
                                        .foregroundColor(.white) 
                                        .font(.system(size: 32, weight: .bold))
                                        .offset(x:-20, y:20)
                                    }
                                    
                                    CustomSearchBarView(text: $searchText) { newValue in
                                        let beverageManager = BeverageManager.shared
                                        let beverages = beverageManager.getUniqueBeverages()
                                        filteredBeverages = beverages.filter { $0.lowercased().contains(newValue.lowercased()) }
                                    }.offset(y: searchText.isEmpty ? 15 : -10)
                                        .frame(width: searchText.isEmpty ? UIScreen.main.bounds.width - 1300 : UIScreen.main.bounds.width - 1010)
                                    .animation(.easeInOut(duration: 0.3), value: searchText.isEmpty)
                                }
                                if !searchText.isEmpty {
                                    ScrollView {
                                        VStack {
                                            ForEach(filteredBeverages.indices, id: \.self) { index in
                                                Text(filteredBeverages[index])
                                                    .font(.title2)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 5)
                                                    .background(Color.white.opacity(0.2))
                                                    .cornerRadius(10)
                                                    .gesture(
                                                        TapGesture()
                                                            .onEnded {
                                                                drinkName = filteredBeverages[index]
                                                                showCustomSelection = true
                                                            }
                                                        )
                                                if index < filteredBeverages.count - 1 {
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 400, height: 400)
                                    .background(Color.clear)
                                    .offset(x:0,y:0)
                                }
                            }
                            if searchText.isEmpty {
                                HStack{
                                    if(!cokeSelected && !cappSelected && !latteSelected) {
                                        Button(action: {
                                            print("Hi")
                                            americanoSelected = !americanoSelected
                                            drinkName = "Americano"
                                        })
                                        {
                                            ZStack{
                                                
                                                FrostyGlass()
                                                    .frame(width: americanoSelected ? screenWidth * buttonWidth * 5 : screenWidth * buttonWidth * 2.5,
                                                           height: americanoSelected ? screenHeight * buttonHeight * 5 : screenHeight * buttonHeight * 2.5)
                                                    .overlay(
                                                        VStack {
                                                            Spacer().frame(height: 250)
                                                            if americanoSelected && sizeOption.isEmpty {
                                                                HStack(spacing: 20) {
                                                                    Button(action: {
                                                                        sizeOption = "Tall"
                                                                        
                                                                    }) {
                                                                        Text("Tall")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                        sizeOption = "Grande"
                                                                    }) {
                                                                        Text("Grande")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                       sizeOption = "Venti"
                                                                    }) {
                                                                        Text("Venti")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    )
                                                
                                                
                                                ZStack{
                                                    if(americanoSelected && sizeOption.isEmpty){
                                                        Text("Select Drink Size").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    if(!sizeOption.isEmpty){
                                                        Text("When Did You Drink It?").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    
                                                    VStack{
                                                        Image("Americano")
                                                            .resizable()
                                                            .frame(width: screenWidth * buttonWidth * 2.5,
                                                                   height: screenHeight * buttonHeight * 2.5)
                                                        Text(sizeOption + " Americano")
                                                            .offset(x: 0, y: -20)
                                                    }
                                                }
                                            }
                                        }.disabled(!sizeOption.isEmpty)
                                            .overlay(
                                                Group {
                                                    if !sizeOption.isEmpty {
                                                        HStack{
                                                            DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                                                .datePickerStyle(CompactDatePickerStyle())
                                                                .scaleEffect(1.5)
                                                                .offset(x:-100)
                                                            
                                                                
                                                            Button(action: {
                                                                var multiplier = 2
                                                                if (sizeOption == "Grande"){
                                                                    multiplier = 3
                                                                }
                                                                if (sizeOption == "Venti"){
                                                                    multiplier = 4
                                                                }
                                                                let newElement: (String, Int, Date) = (sizeOption + " Americano", 75*multiplier, time)
                                                                print(newElement)
                                                                tupleArray.append(newElement)
                                                                resetAll()
                                                                currentCaffeine = calculateCaffeineContent()
                                                            }){
                                                                Image(systemName: "checkmark")
                                                                    .padding(16)
                                                                    .background(Color.gray)
                                                                    .cornerRadius(50)
                                                                .shadow(radius: 2)
                                                            }
                                                        }
                                                        .offset(x: -70, y:120)
                                                    }
                                                }
                                            )
                                    }
                                    if(!americanoSelected && !cappSelected && !latteSelected){
                                        Button(action: {
                                            print("Hi")
                                            cokeSelected = !cokeSelected
                                        }){
                                            ZStack{
                                                FrostyGlass()
                                                    .frame(width: cokeSelected ? screenWidth * buttonWidth * 5 : screenWidth * buttonWidth * 2.5,
                                                           height: cokeSelected ? screenHeight * buttonHeight * 5 : screenHeight * buttonHeight * 2.5)
                                                    .overlay(
                                                        VStack {
                                                            Spacer().frame(height: 250)
                                                            if cokeSelected && sizeOption.isEmpty{
                                                                HStack(spacing: 20) {
                                                                    Button(action: {
                                                                        sizeOption = "8 oz"
                                                                    }) {
                                                                        Text("8 oz")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                       sizeOption = "12 oz"
                                                                    }) {
                                                                        Text("12  oz")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                        sizeOption = "16 oz"
                                                                    }) {
                                                                        Text("16  oz")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    )
                                                
                                                ZStack{
                                                    if(cokeSelected && sizeOption.isEmpty){
                                                        Text("Select Drink Size").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    if(!sizeOption.isEmpty){
                                                        Text("When Did You Drink It?").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    VStack{
                                                        Image("Coke")
                                                            .resizable()
                                                            .frame(width: screenWidth * buttonWidth * 2.5,
                                                                   height: screenHeight * buttonHeight * 2.5)
                                                        Text(sizeOption + " Coke")
                                                        .offset(x:0,y:-20)
                                                    }
                                                }
                                            }
                                        }
                                        .disabled(!sizeOption.isEmpty)
                                        .overlay(
                                            Group {
                                                if !sizeOption.isEmpty {
                                                    HStack{
                                                        DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                                            .datePickerStyle(CompactDatePickerStyle())
                                                            .scaleEffect(1.5)
                                                            .offset(x:-100)
                                                        
                                                        
                                                        Button(action: {
                                                            var caffeine = 1
                                                            if (sizeOption == "8 oz"){
                                                                caffeine = 22
                                                            }
                                                            if (sizeOption == "16 oz"){
                                                                caffeine = 45
                                                            }
                                                            if (sizeOption == "12 oz"){
                                                                caffeine = 34
                                                            }
                                                            let newElement: (String, Int, Date) = (sizeOption + " Coke", caffeine, time)
                                                            print(newElement)
                                                            tupleArray.append(newElement)
                                                            resetAll()
                                                            currentCaffeine = calculateCaffeineContent()
                                                        }){
                                                            Image(systemName: "checkmark")
                                                                .padding(16)
                                                                .background(Color.gray)
                                                                .cornerRadius(50)
                                                                .shadow(radius: 2)
                                                        }
                                                    }
                                                    .offset(x: -70, y:120)
                                                }
                                            }
                                        )
                                    }
                                }
                                
                                HStack{
                                    if(!americanoSelected && !cokeSelected && !latteSelected){
                                        Button(action: {
                                            print("Hi")
                                            cappSelected = !cappSelected
                                        }){
                                            ZStack{
                                                FrostyGlass()
                                                    .frame(width: cappSelected ? screenWidth * buttonWidth * 5 : screenWidth * buttonWidth * 2.5,
                                                           height: cappSelected ? screenHeight * buttonHeight * 5 : screenHeight * buttonHeight * 2.5)
                                                    .overlay(
                                                        VStack {
                                                            Spacer().frame(height: 250)
                                                            if cappSelected && sizeOption.isEmpty {
                                                                HStack(spacing: 20) {
                                                                    Button(action: {
                                                                       sizeOption = "Tall"
                                                                    }) {
                                                                        Text("Tall")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                        sizeOption = "Grande"
                                                                    }) {
                                                                        Text("Grande")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                        sizeOption = "Venti"
                                                                    }) {
                                                                        Text("Venti")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    )
                                                ZStack{
                                                    if(cappSelected && sizeOption.isEmpty){
                                                        Text("Select Drink Size").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    if(!sizeOption.isEmpty){
                                                        Text("When Did You Drink It?").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    VStack{
                                                        Image("Cappuccino")
                                                            .resizable()
                                                            .frame(width: screenWidth * buttonWidth * 2.5,
                                                                   height: screenHeight * buttonHeight * 2.5)
                                                        Text(sizeOption + " Cappuccino")
                                                        .offset(x:0,y:-20)
                                                    }
                                                }
                                            }
                                        }.offset(x:0,y:-20)
                                            .disabled(!sizeOption.isEmpty)
                                            .overlay(
                                                Group {
                                                    if !sizeOption.isEmpty {
                                                        HStack{
                                                            DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                                                .datePickerStyle(CompactDatePickerStyle())
                                                                .scaleEffect(1.5)
                                                                .offset(x:-100)
                                                            
                                                            
                                                            Button(action: {
                                                                var multiplier = 2
                                                                if (sizeOption == "Tall"){
                                                                    multiplier = 1
                                                                }
                                                                let newElement: (String, Int, Date) = (sizeOption + " Cappuccino", 75*multiplier, time)
                                                                print(newElement)
                                                                tupleArray.append(newElement)
                                                                resetAll()
                                                                currentCaffeine = calculateCaffeineContent()
                                                            }){
                                                                Image(systemName: "checkmark")
                                                                    .padding(16)
                                                                    .background(Color.gray)
                                                                    .cornerRadius(50)
                                                                    .shadow(radius: 2)
                                                            }
                                                        }
                                                        .offset(x: -70, y:120)
                                                    }
                                                }
                                            )
                                    }
                                    if(!americanoSelected && !cokeSelected && !cappSelected){
                                        Button(action: {
                                            print("Hi")
                                            latteSelected = !latteSelected
                                        }){
                                            ZStack{
                                                FrostyGlass()
                                                    .frame(width: latteSelected ? screenWidth * buttonWidth * 5 : screenWidth * buttonWidth * 2.5,
                                                           height: latteSelected ? screenHeight * buttonHeight * 5 : screenHeight * buttonHeight * 2.5)
                                                    .overlay(
                                                        VStack {
                                                            Spacer().frame(height: 250)
                                                            if latteSelected && sizeOption.isEmpty {
                                                                HStack(spacing: 20) {
                                                                    Button(action: {
                                                                        sizeOption = "Tall"
                                                                    }) {
                                                                        Text("Tall")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                        sizeOption = "Grande"
                                                                    }) {
                                                                        Text("Grande")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                    Button(action: {
                                                                        sizeOption = "Venti"
                                                                    }) {
                                                                        Text("Venti")
                                                                            .padding(.horizontal, 30)
                                                                            .padding(.vertical, 20)
                                                                            .background(Color.gray)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    )
                                                ZStack{
                                                    if(latteSelected && sizeOption.isEmpty){
                                                        Text("Select Drink Size").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    if(!sizeOption.isEmpty){
                                                        Text("When Did You Drink It?").font(.title)
                                                            .bold()
                                                            .offset(y:-130)
                                                    } 
                                                    VStack{
                                                        Image("Latte")
                                                            .resizable()
                                                            .frame(width: screenWidth * buttonWidth * 2.5,
                                                                   height: screenHeight * buttonHeight * 2.5)
                                                        Text(sizeOption + " Latte")
                                                        .offset(x:0,y:-20)
                                                    }
                                                }
                                            }
                                        }.offset(x:0,y:-20)
                                            .disabled(!sizeOption.isEmpty)
                                            .overlay(
                                                Group {
                                                    if !sizeOption.isEmpty {
                                                        HStack{
                                                            DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                                                .datePickerStyle(CompactDatePickerStyle())
                                                                .scaleEffect(1.5)
                                                                .offset(x:-100)
                                                            
                                                            
                                                            Button(action: {
                                                                var multiplier = 2
                                                                if (sizeOption == "Tall"){
                                                                    multiplier = 1
                                                                }
                                                                let newElement: (String, Int, Date) = (sizeOption + " Latte", 75*multiplier, time)
                                                                print(newElement)
                                                                tupleArray.append(newElement)
                                                                resetAll()
                                                                currentCaffeine = calculateCaffeineContent()
                                                            }){
                                                                Image(systemName: "checkmark")
                                                                    .padding(16)
                                                                    .background(Color.gray)
                                                                    .cornerRadius(50)
                                                                    .shadow(radius: 2)
                                                            }
                                                        }
                                                        .offset(x: -70, y:120)
                                                    }
                                                }
                                            )
                                    }
                                }
                            }
                        }
                    }
                    if(settingsScreenVisible){
                        VStack{
                            Text("Settings")
                            .foregroundColor(.white) 
                                .bold()
                                .font(.system(size: 32, weight: .bold))
                                //.offset(x:-120)
                            Divider()
                                .frame(width:screenWidth - mainViewWidthOffset*1.2)
                            .background(Color.white)
                            HStack{
                                Button(action: {
                                    print("Hi")
                                    backgroundSelection = "background_coffeeshop"
                                    musicPlayer.playBackgroundMusic(backgroundSelection: backgroundSelection)
                                }){
                                    Image("background_coffeeshop")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    
                                }
                                Button(action: {
                                    print("Hi")
                                    backgroundSelection = "background_forest"
                                    musicPlayer.playBackgroundMusic(backgroundSelection: backgroundSelection)
                                }){
                                    Image("background_forest")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    
                                }
                            }
                            
                            Text("Select Background")
                            .foregroundColor(.white) 
                            Divider()
                                .frame(width:screenWidth - mainViewWidthOffset*1.2)
                                .background(Color.white)
                            Text("Acknowledgements")
                            .foregroundColor(.white) 
                                .bold()
                                .font(.system(size: 32, weight: .bold))
                            Text("")
                            Text("Sound Effects by freesound_community from Pixabay") 
                            .foregroundColor(.white) 
                            Text("Images created with Image Playground by Apple")
                            .foregroundColor(.white) 
                            Text("Caffeine content dataset from reisanar on GitHub")
                            .foregroundColor(.white) 
                            Text("")
                            Text("Submitted for Swift Student Challenge 2025")
                            .foregroundColor(.white) 
                            Text("")
                            Text("© Rafael Auerswald, 2025")
                            .foregroundColor(.white) 
                        }
                        
                        
                    }
                    if(dataScreenVisible){
                        if(triviaSection == 0){
                            VStack{
                                Image("TalkingCup").resizable()
                                    .frame(width: screenWidth * buttonWidth * 2.5,
                                           height: screenHeight * buttonHeight * 2.5)
                                    .cornerRadius(20)
                                Text("Caffeine Trivia")
                                .foregroundColor(.white)
                                    .bold()
                                    .font(.system(size: 32, weight: .bold))
                                Text("")
                                Text("Welcome to the Decaffeinato Trivia Quiz!")
                                .foregroundColor(.white)
                                Text("I'm your host, Beanley.")
                                Text("Let's learn some stuff about coffee!")
                                .foregroundColor(.white)
                                Button(action: {
                                    triviaSection = triviaSection+1
                                }){
                                    Text("I'm ready!")
                                    .foregroundColor(.white)
                                }
                                .padding(16)
                                .background(Color.gray)
                                .cornerRadius(50)
                                .shadow(radius: 2)
                            }
                        }
                        else{
                            VStack{
                                Image("TalkingCup").resizable()
                                    .frame(width: screenWidth * buttonWidth * 2.5,
                                           height: screenHeight * buttonHeight * 2.5)
                                Text(triviaAnswer[triviaSection])
                                    .frame(width:400)
                                .foregroundColor(.white) 
                                Text("")
                                Text(triviaQuestion[triviaSection])
                                    .bold()
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(width:400)
                                .foregroundColor(.white) 
                                Text("")
                                HStack{
                                    Button(action: {
                                        if(triviaCorrect[triviaSection].0){
                                           triviaSection = triviaSection+1 
                                        }
                                        else{
                                            triviaWrongButtonPressed[triviaSection].0 = true
                                        }
                                        
                                    }){
                                        Text(triviaChoice[triviaSection].0)
                                    }
                                    .padding(16)
                                    .background(triviaWrongButtonPressed[triviaSection].0 ? Color.red : Color.gray)
                                    .cornerRadius(50)
                                    .shadow(radius: 2)
                                    Button(action: {
                                        if(triviaCorrect[triviaSection].1){
                                            if(triviaSection==6){
                                                triviaSection = triviaSection-6
                                                triviaWrongButtonPressed = [
                                                    (false, false, false),
                                                    (false, false, false),
                                                    (false, false, false),
                                                    (false, false, false),
                                                    (false, false, false),
                                                    (false, false, false),
                                                    (false, false, false)
                                                ] //RESET RED BUTTONS
                                            }
                                            else{
                                                triviaSection = triviaSection+1
                                            }
                                        }
                                        else{
                                            triviaWrongButtonPressed[triviaSection].1 = true
                                        }
                                        
                                    }){
                                        Text(triviaChoice[triviaSection].1)
                                    }
                                    .padding(16)
                                    .background(triviaWrongButtonPressed[triviaSection].1 ? Color.red : Color.gray)
                                    .cornerRadius(50)
                                    .shadow(radius: 2)
                                    Button(action: {
                                        if(triviaCorrect[triviaSection].2){
                                            triviaSection = triviaSection+1
                                        }
                                        else{
                                            triviaWrongButtonPressed[triviaSection].2 = true
                                        }
                                        
                                    }){
                                        Text(triviaChoice[triviaSection].2)
                                    }
                                    .padding(16)
                                    .background(triviaWrongButtonPressed[triviaSection].2 ? Color.red : Color.gray)
                                    .cornerRadius(50)
                                    .shadow(radius: 2)
                                }
                            }
                        }
                    }
                    
                }
                Spacer().frame(height: topBottomSpacing)
                ZStack {
                    HStack(spacing: buttonSpacing) {
                        Button(action: {
                            AudioServicesPlaySystemSound(1052)
                            if(!settingsScreenVisible){
                                mainScreenVisible = false
                                dataScreenVisible = false
                                settingsScreenVisible = true
                                addScreenVisible = false
                                americanoSelected = false
                                cokeSelected = false
                                cappSelected = false
                                latteSelected = false
                                searchText = ""
                                sizeOption = ""
                                drinkName = ""
                                showCustomSelection = false
                                height = 300
                            }
                            else{
                                mainScreenVisible = true
                                dataScreenVisible = false
                                settingsScreenVisible = false
                                addScreenVisible = false
                                americanoSelected = false
                                cokeSelected = false
                                cappSelected = false
                                latteSelected = false
                                currentCaffeine = calculateCaffeineContent()
                            }
                        }) {
                            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                .opacity(opacity)
                                .frame(width: screenWidth * buttonWidth * (settingsScreenVisible ? 1.5 : 1.0),
                                       height: screenHeight * buttonHeight)
                                .overlay(Color.white.opacity(overlayOpacity))
                                .cornerRadius(cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .stroke(Color.white.opacity(strokeOpacity), lineWidth: strokeWidth)
                                )
                                .overlay(
                                    Image(systemName: "gear")
                                        .font(fontSize)
                                        .foregroundColor(.white)
                                        .rotationEffect(settingsScreenVisible ? Angle(degrees:360) : Angle(degrees:0))
                                )
                                .animation(.linear(duration: animationDuration), value: settingsScreenVisible)
                        }
                        Button(action: {
                            AudioServicesPlaySystemSound(1052)
                            if(!addScreenVisible){
                                mainScreenVisible = false
                                dataScreenVisible = false
                                settingsScreenVisible = false
                                addScreenVisible = true
                                currentCaffeine = calculateCaffeineContent()
                            }
                            else{
                                mainScreenVisible = true
                                dataScreenVisible = false
                                settingsScreenVisible = false
                                addScreenVisible = false
                                americanoSelected = false
                                cokeSelected = false
                                cappSelected = false
                                latteSelected = false
                                searchText = ""
                                sizeOption = ""
                                drinkName = ""
                                showCustomSelection = false
                                height = 300
                                currentCaffeine = calculateCaffeineContent()
                            }
                        }) {
                            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                .opacity(opacity)
                                .frame(width: screenWidth * buttonWidth * (mainScreenVisible||addScreenVisible ? 1.5 : 1.0),
                                       height: screenHeight * buttonHeight * (addScreenVisible ? 1.5 : 1.0))
                                .overlay(Color.white.opacity(overlayOpacity))
                                .cornerRadius(cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .stroke(Color.white.opacity(strokeOpacity), lineWidth: strokeWidth)
                                )
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(fontSize)
                                        .scaleEffect(1.6)
                                        .scaleEffect(addScreenVisible ? 1.5 : 1)
                                        .foregroundColor(.white)
                                        .rotationEffect(addScreenVisible ? Angle(degrees:45) : Angle(degrees:0))
                                ).animation(.linear(duration: animationDuration), value: dataScreenVisible)
                                .animation(.linear(duration: animationDuration), value: settingsScreenVisible)
                        }
                        Button(action: {
                            AudioServicesPlaySystemSound(1052)
                            if(!dataScreenVisible){
                                mainScreenVisible = false
                                dataScreenVisible = true
                                settingsScreenVisible = false
                                addScreenVisible = false
                                americanoSelected = false
                                cokeSelected = false
                                cappSelected = false
                                latteSelected = false
                                searchText = ""
                                sizeOption = ""
                                drinkName = ""
                                showCustomSelection = false
                                height = 300
                            }
                            else{
                                mainScreenVisible = true
                                dataScreenVisible = false
                                settingsScreenVisible = false
                                addScreenVisible = false
                                americanoSelected = false
                                cokeSelected = false
                                cappSelected = false
                                latteSelected = false
                                currentCaffeine = calculateCaffeineContent()
                            }
                        }) {
                            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                .opacity(opacity)
                                .frame(width: screenWidth * buttonWidth * (dataScreenVisible ? 1.5 : 1.0),
                                       height: screenHeight * buttonHeight)
                                .overlay(Color.white.opacity(overlayOpacity))
                                .cornerRadius(cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .stroke(Color.white.opacity(strokeOpacity), lineWidth: strokeWidth)
                                )
                                .overlay(
                                    Image(systemName: "chart.bar")
                                        .font(fontSize)
                                        .foregroundColor(.white)
                                    
                                ) .animation(.linear(duration: animationDuration), value: dataScreenVisible)
                        }
                    }
                }
            }
        }
    }
}

struct GraphView: View {
    let currentCaffeine: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            let dataPoints: [(x: Double, y: Double)] = [
                (0, currentCaffeine),
                (4, currentCaffeine / 2),
                (8, currentCaffeine / 4),
                (12, currentCaffeine / 8)
            ]
            
            let maxX = 12.0
            let maxY = currentCaffeine
            
            let points = dataPoints.map { point in
                CGPoint(
                    x: CGFloat(point.x / maxX) * width,
                    y: height * (1 - CGFloat(point.y / maxY))
                )
            }
            
            let baseDate = Date()
            let dateFormatter: DateFormatter = {
                let df = DateFormatter()
                df.dateFormat = "h:mm a"
                return df
            }()
            
            ZStack {
                ForEach(0..<5) { i in
                    let fraction = Double(i) / 4.0
                    let yValue = fraction * maxY
                    let yPosition = height * (1 - CGFloat(fraction))
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yPosition))
                        path.addLine(to: CGPoint(x: width, y: yPosition))
                    }
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    
                    Text(String(format: "%.0f", yValue))
                        .font(.caption)
                        .foregroundColor(.white)
                        .position(x: -20, y: yPosition)
                }
                
                Path { path in
                    if let first = points.first {
                        path.move(to: first)
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.white, lineWidth: 2)
                
                ForEach(0..<4) { index in
                    let hourOffset = index * 4
                    let labelDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: baseDate) ?? baseDate
                    let timeString = dateFormatter.string(from: labelDate)
                    Text(timeString)
                        .font(.caption)
                        .foregroundColor(.white)
                        .position(
                            x: CGFloat(Double(index * 4) / maxX) * width,
                            y: height + 20
                        )
                }
            }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        view.effect = effect
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
    
}
struct SearchBarView: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for drink or choose one below", text: $searchText)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
struct FrostyGlass: View {
    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            .opacity(0.9)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                    .fill(Color.white.opacity(0.25))
                ) //MAKE THE GLASS MILKY
    }
}
struct CustomSearchBarView: View {
    @Binding var text: String
    var onTextChanged: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .onChange(of: text) { newValue in
                    onTextChanged(newValue)
                }
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                .padding(.horizontal, 10)
                .padding(.top, 10)
        )
    }
}
