return {
    descriptions = {
        Back = {

        },
        Other = {
            prize_stat = {
                name = "Parlor",
                text = {
                    "{C:attention}#1#{}",
                    "is {C:money}prized{}"
                }
            },
            empty_stat = {
                name = "Parlor",
                text = {
                    "{C:attention}#1#{}",
                    "is {C:red}not{} {C:money}prized{}"
                }
            },
            empty2_stat = {
                name = "Parlor",
                text = {
                    "{C:attention}#1#{} and",
                    "{C:attention}#2#{} are",
                    "{C:red}not{} {C:money}prized{}"
                }
            },
            two_true_stat = {
                name = "Parlor",
                text = {
                    "Two {C:attention}Jokers{} tell",
                    "the {C:green}truth{}"
                }
            },
            two_false_stat = {
                name = "Parlor",
                text = {
                    "Two {C:attention}Jokers{}",
                    "tell {C:red}lies{}"
                }
            },
            truther_stat = {
                name = "Parlor",
                text = {
                    "{C:attention}#1#{} tells",
                    "the {C:green}truth{}"
                }
            },
            liar_stat = {
                name = "Parlor",
                text = {
                    "{C:attention}#1#{} {C:red}lies{}",
                }
            },
        },
        Enhanced = {

        },
        Joker = {

        },
        Spectral = {

        },
        Experiment = {
            c_bp_experiment = {
                name = "Experiment",
                text = {
                }
            }
        },
        ExperimentCauses = {
            none = {
                text = {
                    'Never,'
                }
            },
            item_bought_lose_3 = {
                text = {
                    "When an {C:attention}Item{} is",
                    "{C:money}bought{} lose {C:red}$3{}",
                    "and then,"
                },
            },
            skip_booster = {
                text = {
                    "When a {C:attention}Booster Pack{}", 
                    "is {C:attention}skipped{},"
                },
            },
            skip_blind = {
                text = {
                    "When a {C:attention}Blind{}", 
                    "is {C:attention}skipped{},"
                },
            },
            immediately = {
                text = {
                    "Immediately,"
                },
            },
            sell_joker_with_retrigger = {
                text = {
                    "When a {C:attention}Joker{} with the word", 
                    "{C:blue}\"All\"{} is {C:attention}sold{},"
                },
            },
            next_5_spectral_use = {
                text ={
                    "The next {C:attention}#1#{} times a", 
                    "{C:spectral}Spectral{} is {C:attention}used{},"
                }
            },
            destroy_enhanced_playing_card = {
                text = {
                    "When an {C:attention}Enhanced{}",
                    "card is {C:red}destroyed{},"
                },
            },
            randomly_each_round = {
                text = {
                    "{C:attention}Randomly{} each {C:attention}round{},"
                },
            },
        },
        ExperimentEffects = {
            none = {
                text = {
                    'Do nothing'
                }
            },
            earn_5_dollars = {
                text = {
                    "Earn {C:money}$5{}",
                },
            },
            upgrade_3_hands = {
                text = {
                    "Upgrade {C:attention}3{} hands",
                },
            },
            create_negative_immediately_experiment = {
                text = {
                    "Create a {C:dark_edition}Negative{} {C:attention}Experiment{}",
                    "with an {C:blue}\"Immediately,\"{} cause",
                },
            },
            create_joker = {
                text = {
                    "Create a {C:attention}Joker{}",
                    "{C:inactive}(must have room){}"
                }
            },
            use_wheel_of_fortune = {
                text = {
                    "Use a {C:tarot}Wheel{}",
                    "{C:tarot}of Fortune{}",
                },
            },
            add_last_used_tarot_to_pool = {
                text = {
                   "Add the last used {C:tarot}Tarot{}",
                   "card to the {C:tarot}Tarot{} pool",
                },
            },
            ["2_percent_probabilities"] = {
                text = {
                    "Increase all probabilities", 
                    "by {C:green}2%{}",
                },
            },
            reroll_tags = {
                text = {
                    "{C:green}Reroll{} skip", 
                    "{C:attention}tags{} this {C:attention}ante{}",
                },
            },
            smg_special = {
                text = {
                    "Add {C:attention}3 Aquariums{} to", 
                    "the {C:attention}Joker Pool{}",
                },
            },
        },
        MidShelteredJoker = {
            j_bp_aquarium = {
                name = "Aquarium",
                text = {
                    "{C:attention}Copies{} all owned",
                    "{C:blue}Common{} {C:attention}Jokers{}",
                    "{C:inactive}[]{}",
                    "{C:red}Sheltered!{}"
                }
            },
            j_bp_darkroom = {
                name = "Darkroom",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                    "{C:inactive}[Jokers in shop{}",
                    "{C:inactive}are face down]{}",
                    "{C:red}Sheltered!{}"
                }
            },
            j_bp_lavatory = {
                name = "Lavatory",
                text = {
                    "Create a {C:planet}Planet{} card",
                    "when a card is {C:red}destroyed{}",
                    "{C:inactive}(must have room){}",
                    "{C:inactive}[Does nothing]{}",
                    "{C:red}Sheltered!{}"
                }
            },
            j_bp_archives = {
                name = "Archives",
                text = {
                    "{C:attention}+#1#{} card slot,",
                    "{C:inactive}[+1 card in shop slots]{}",
                    "{C:inactive}[and packs are face down]{}",
                    "{C:red}Sheltered!{}"
                }
            }
        },
        ShelteredJoker = {
            j_bp_aquarium = {
                name = "Aquarium",
                text = {
                    "{C:attention}Copies{} all owned",
                    "{C:blue}Common{} {C:attention}Jokers{}",
                }
            },
            j_bp_darkroom = {
                name = "Darkroom",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                }
            },
            j_bp_lavatory = {
                name = "Lavatory",
                text = {
                    "Create a {C:planet}Planet{} card",
                    "when a {C:attention}card{} is {C:red}destroyed{}",
                    "{C:inactive}(must have room){}"
                }
            },
            j_bp_archives = {
                name = "Archives",
                text = {
                    "{C:attention}+#1#{} card slot",
                }
            }
        }
    },
    misc = {
        dictionary = {
            b_experiments = "Experiments",
            k_experiment = "Experiment",
            b_experiment_cards = "Experiment Cards",
            k_ex_bedroom = "Bedroom!",
            k_evicted = "Evicted",
        },
        v_text = {
            
        },
        v_dictionary = {
        },
        challenge_names = {

        },
        labels = {

        },
        ranks = {

        },
        suits_singular = {

        },
        suits_plural = {

        },
        poker_hands = {

        },
        poker_hand_descriptions = {

        },
    }
}