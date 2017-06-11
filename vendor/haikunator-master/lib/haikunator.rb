require "haikunator/version"
require "securerandom"

module Haikunator
  class << self
    def haikunate(token_range = 9999, delimiter = "-")
      build(token_range, delimiter)
    end

    private

    def build(token_range, delimiter)
      sections = [
        adjectives[random_seed % adjectives.length],
        nouns[random_seed % nouns.length],
        token(token_range)
      ]

      sections.compact.join(delimiter)
    end

    def random_seed
      SecureRandom.random_number(4096)
    end

    def token(range)
      SecureRandom.random_number(range) if range > 0
    end

    def adjectives
      %w(
        able achy acid aery affy aged agog airy ajar akin alar alto amok anti aqua arch arid arts arty ashy auld aval avid away awed awny awol awry back bald bare base bass bent best beta bird blae blue bold bond bone bony boon born both boxy braw brut buff bust busy cade cagy calm camp chic clad coil cold cool cosy cozy curl curt cute cyan daft damp dank darn dead deaf dear deep deft demy dewy dink dire dirk dirt done dopy dour down dozy drab dree dual dull duly dumb dyed each east easy edgy eery eggy else eoan epic even eyas eyed fain fair fake fast fate faux feal feed fell fere fine firm five flat fond foot four foxy free frow full fumy gaga game gamy geal gilt glad glib glum gold gone good gory gray grey grim grum gyre hale half halt hard haut hazy here hewn hick high hind hoar holy home homy hued huge hurt iced idle inky inly inst iron junk just keen kept kind king lacy laic laid laky lame lane lang lank last late lazy leal lean leer left lent less lest lewd like limb limp limy lite live loco logy lone long lorn lost loth loud lush luxe made main male malt many matt maxi mazy mean meek mere midi mild mini mint mirk miry mock moll mono mood moot more mown much must mute naif nary neap near neat need nett next nice nigh nine nisi none noon nosy nude null okay only oozy open otic oval over paid pale paly past pent pert pied pily pink piny plus poem poky poor port posh prim prox puce puff puny pure racy rapt rare rash real rial rich rife rima rimy ripe rite road roan ropy rose rosy ruby rude ruly rush rust safe sage said salt same sane sear seen sent sere sewn sexy sham shed shod shot shut sick skew slim slow smug snub snug soft sola sold sole some sore sown spry such sunk surd sure tabu tall tame tart taut teal teen tern then thin tidy tied tiny toed tops torn tref trig trim true tube twee uber uric used vain vast vile void warm wary wavy waxy weak well welt west wide wild wily winy wiry wise worn yare your zany shy misty icy old red vocal
      )
    end

    def nouns
      %w(
        map pan pet pie pig pot rat sun toe tub van apple bike bird book chin clam class club corn crow crown desk dime dirt dress fang field flag flower fog game heat hill home horn joke kite lake mask mice mint meal moon name nest nose pear pen plant rain river road rock room rose seed shoe shop show sink snail snake snow soda sofa star step stew stove straw string summer swing table tank team tent test toes tree vest water wing winter robin sail soap toad spy song music wren title sugar quilt jam owl sea trip goose deer dock camp bath tree pond sun glade bird fog smoke star voice pine dew dust hill cloud lake sea bat pen six fox tub tap peg pig bud rat egg pin sun pod cup map leg pip mop rug can web bib cot bus elf wig ox bun ham hem ink dot gum den cod mud elk bin rum elm bog rut keg rim hog ant jet fin fog cub lip mop pup lap pop bug sap sod bot aura bee beak boar brow cult fern flea word haze sky shape surf sing night dawn leaf fire grass sound city set art dance life foam day rest sail end eye bell kitty cat dog air run walk talk swim
      )
    end
  end
end
