//
//  Home.swift
//  UI-606
//
//  Created by nyannyan0328 on 2022/07/06.
//

import SwiftUI

struct Home: View {
    @State var selectedPizza : Pizza = pizzas[0]
    @State var swipDelection : Alignment = .center
    @State var currentTab : String = "MEDIUM"
    @State var animatedPizza : Bool = false
    @Namespace var animation
    var body: some View {
        VStack{
            

            HStack{
                
                Button {
                    
                } label: {
                    
                    Image("Menu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30,height: 30)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    
                    Image("p1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                         .frame(width: 60,height: 60)
                         .clipShape(Circle())
                }
                
                


            }
            .overlay {
                
                
                Text(attString)
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.black)
                
            }
            
            Text("Slected Youre Pizza")
                .font(.title2.bold())
                .foregroundColor(.orange.opacity(0.3))
            
            AnimatedSlider()
            
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
          .background{
           
              Rectangle()
                  .fill(Color("BG"))
                  .ignoresSafeArea()
          }
    }
    @ViewBuilder
   func AnimatedSlider()->some View{
        
        GeometryReader{proxy in
            
             let size = proxy.size
            
            LazyHStack(spacing:0){
                
                ForEach(pizzas){pizza in
                    
                    let index = getIndex(pizza: pizza)
                    
                    let mainIndex = getIndex(pizza: selectedPizza)
                    
                    VStack{
                        
                        Text(pizza.pizzaTitle)
                            .font(.callout)
                        
                        Text(pizza.pizzaDescription)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                    }
                    .frame(width: size.width,height: size.height,alignment: .top)
                    .rotationEffect(.init(degrees: mainIndex == index ? 0 : (index > mainIndex ? 180 : -180)))
                    .offset(x:-CGFloat(mainIndex) * size.width,y:index == mainIndex ? 0 : 40)
                }
                
                
           
            }
            
            PizzaView()
                .padding(.top,120)
            
            
            
        }
        
        
    }
    
   @ViewBuilder
    func PizzaView()->some View{
        
        GeometryReader{proxy in
             let size = proxy.size
            
            ZStack(alignment:.top){
                
                Image(selectedPizza.pizzaImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,height:size.height)
                
                    .background(alignment:.top){
                     
                        Image("Powder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width)
                            .offset(y:-30)
                    }
                    .scaleEffect(1.05,anchor: .top)
                
                
                ZStack(alignment:.top){
                    
                    if selectedPizza.id != pizzas.first?.id{
                        
                        
                        
                        AricShape()
                            .trim(from: 0.05,to: 0.3)
                            .stroke(.gray,lineWidth: 2)
                            .offset(y:75)
                        
                        Image(systemName: "chevron.left")
                            .rotationEffect(.init(degrees: -30))
                            .offset(x:-(size.width / 2) + 30,y: 55)
                        
                    }
                    
                   
                    
                 
                    
                    
                    
                    if selectedPizza.id != pizzas.last?.id{
                        
                        
                        AricShape()
                            .trim(from: 0.7,to: 0.96)
                            .stroke(.gray,lineWidth: 2)
                            .offset(y:75)
                        
                        Image(systemName: "chevron.right")
                            .rotationEffect(.init(degrees: 30))
                            .offset(x:(size.width / 2) - 30,y: 55)
                        
                    }
                    
                    Text(priceAttString(value:selectedPizza.pizzaPrice))
                        .font(.largeTitle.weight(.black))
                    
                }
                .offset(y:-80)
            
                
            }
            .rotationEffect(.init(degrees: animatedPizza ? (swipDelection == .leading ? -360 : 360) : 0))
            .offset(y:size.height / 2)
            .gesture(
            
            DragGesture()
                .onEnded{value in
                    
                    let translation = value.translation.width
                    
                    let index = getIndex(pizza: selectedPizza)
                    
                    if animatedPizza{return}
                    
                    if translation < 0 && -translation > 50 && index != (pizzas.count - 1){
                        
                        swipDelection = .leading
                        handleSwip()
                    }
                    
                    if translation > 0 && translation > 50 && index > 0{
                        
                        swipDelection = . trailing
                        handleSwip()
                    }
                    
                }
            )
            
            
            HStack{
                
                ForEach(["SMALL","MEDIUM","LARGE"],id: \.self){type in
                    
                    Text(type)
                        .font(currentTab == type ? .title :.caption2 )
                        .lineLimit(1)
                      .frame(maxWidth: .infinity,alignment: .center)
                      .overlay(content: {
                          
                          if currentTab == type{
                              
                              Capsule()
                                  .foregroundColor(.green)
                                   .frame(width: 10,height: 10)
                                   .offset(y:22)
                                   .scaleEffect(1.5)
                          }
                      })
                      .contentShape(Rectangle())
                      .onTapGesture {
                          
                          withAnimation{
                              currentTab = type
                          }
                      }
                      
                    
                    
                }
            }
            .padding(.vertical)
            .background{
             
                ZStack(alignment:.top){
                    
                    Rectangle()
                        .trim(from: 0.25,to: 1)
                        .stroke(.gray,lineWidth: 1)
                    
                    
                    Rectangle()
                        .trim(from: 0,to: 0.17)
                        .stroke(.gray,lineWidth: 1)
                    
                    Text("SIZE")
                        .font(.callout)
                        .offset(y:-10)
                }
                    
            }
            
            
        }
        
        
    }
    
    func handleSwip(){
        
        let index = getIndex(pizza: selectedPizza)
        
        if swipDelection == .leading{
            
            withAnimation(.easeOut(duration: 0.8)){
                
                selectedPizza = pizzas[index + 1]
                animatedPizza = true
                
            }
            
        }
        if swipDelection == .trailing{
            
            withAnimation(.easeOut(duration: 0.8)){
                
                selectedPizza = pizzas[index - 1]
                animatedPizza = true
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            
            animatedPizza = false
        }
    }
    
    func priceAttString(value : String)->AttributedString{
        
        var str = AttributedString(stringLiteral: value)
        
        if let range = str.range(of: "$"){
            
            str[range].font = .system(size: 10,weight: .black)
        }
        return str
    }

    var attString :AttributedString{
        
        var str = AttributedString(stringLiteral: "EATPIZZA")
        
        if let range = str.range(of: "PIZZA"){
            
            str[range].foregroundColor = .gray
            
            
        }
        return str
        
    }
    
    func getIndex(pizza : Pizza)->Int{
        
        return pizzas.firstIndex { CAZZA in
            
            CAZZA.id == pizza.id
        } ?? 0
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
