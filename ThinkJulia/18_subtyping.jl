# Card --------------------------------------------------------------------
"""
♠ ↦ 4
♥ ↦ 3
♦ ↦ 2
♣ ↦ 1
"""
struct Card
    suit :: Int64
    rank :: Int64
    function Card(suit::Int64, rank::Int64)
        @assert(1 ≤ suit ≤ 4, "suit is not between 1 and 4")
        @assert(1 ≤ rank ≤ 13, "rank is not between 1 and 13")
        new(suit, rank)
    end
end

queen_of_diamonds = Card(2, 12)


# Global Variables --------------------------------------------------------
const suit_names = ["♣", "♦", "♥", "♠"]
const rank_names = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

function Base.show(io::IO, card::Card)
    print(io, rank_names[card.rank], suit_names[card.suit])
end

Card(3, 11)


# Comparing Cards ---------------------------------------------------------
import Base.<

function <(c1::Card, c2::Card)
    (c1.suit, c1.rank) < (c2.suit, c2.rank)
end
### OBS: The relational operators work with tuples and other sequences; 
### Julia starts by comparing the first element from each sequence. 
### If they are equal, it goes on to the next elements, and so on, until it finds elements that differ. 
### Subsequent elements are not considered


# Unit Testing ------------------------------------------------------------
using Test

@test Card(1, 4) < Card(2, 4)
@test Card(1, 3) < Card(1, 4)


# Decks -------------------------------------------------------------------
struct Deck
    cards :: Array{Card, 1}
end

function Deck()
    deck = Deck(Card[])
    for suit in 1:4
        for rank in 1:13
            push!(deck.cards, Card(suit, rank))
        end
    end
    deck
end

function Base.show(io::IO, deck::Deck)
    for card in deck.cards
        print(io, card, " ")
    end
    println()
end

Deck()


# Add, Remove, Shuffle and Sort -------------------------------------------
function Base.pop!(deck::Deck)
    pop!(deck.cards)
end

function Base.push!(deck::Deck, card::Card)
    push!(deck.cards, card)
    deck
end

using Random

function Random.shuffle!(deck::Deck)
    shuffle!(deck.cards)
    deck
end


# Abstract Types and Subtyping --------------------------------------------
### We need a way to group related concrete types. 
### In Julia this is done by defining an abstract type that serves as a parent for both Deck and Hand. 
### This is called subtyping

abstract type CardSet end

### We can now express that Deck is a descendant of CardSet
struct Deck <: CardSet
    cards :: Array{Card, 1}
end

### A hand is also a kind of CardSet
struct Hand <: CardSet
    cards :: Array{Card, 1}
    label :: String
end

function Hand(label::String="")
    Hand(Card[], label)
end

deck = Deck()
deck isa CardSet

hand = Hand("new hand")
hand isa CardSet


# Abstract Types and Functions --------------------------------------------
### We can now express the common operations between Deck and Hand as functions having as argument CardSet
function Base.show(io::IO, cs::CardSet)
    for card in cs.cards
        print(io, card, " ")
    end
end

function Base.pop!(cs::CardSet)
    pop!(cs.cards)
end

function Base.push!(cs::CardSet, card::Card)
    push!(cs.cards, card)
    return nothing
end

### move! takes three arguments, two Cardset objects and the number of cards to deal. It modifies both Cardset objects, and returns nothing
function move!(cs1::CardSet, cs2::CardSet, n::Int)
    @assert 1 ≤ n ≤ length(cs1.cards)
    for i in 1:n
        card = pop!(cs1)
        push!(cs2, card)
    end
    nothing
end


# Exercise 18-2 -----------------------------------------------------------
Base.isless(c1::Card, c2::Card) = <(c1::Card, c2::Card)

function Base.sort!(deck::Deck)
    sort!(deck.cards)
    deck
end

x = Deck()
shuffle!(x)
sort!(x)

@which sort!(x)


# Exercise 18-5 -----------------------------------------------------------
function deal!(deck::Deck, n_hands, n_cards_per_hand)
    hands = Hand[]
    shuffle!(deck)
    for i in 1:n_hands
        push!(hands, Hand())
        move!(deck, hands[i], n_cards_per_hand)
    end

    return hands
end

deal!(Deck(), 5, 7)