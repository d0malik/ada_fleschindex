-- ########################################
-- PROGRAM:     FLESCH INDEX CALCULATOR
-- DESCRIPTION: THIS CALCULATES THE FLESCH
--              INDEX OF THE GIVEN INPUT FILE
-- NAME:        DANIEL DOMALIK
-- STUDENT ID:  0933553
-- DATE:        04/13/2018
-- COMPILER:    GNATMAKE
-- ########################################

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Strings.Fixed;
with Ada.Strings.Maps.Constants;

procedure a4 is
    File: file_type;
    lineIn: Unbounded_String;
    fileName: Unbounded_String;
    sentences: Natural := 0;
    syllables: Natural := 0;
    words: Natural := 0;
    j: Natural := 0;
    fleschIndex: Float := 0.00;

    function Flesch_Kincaid(sentences : in Natural; syllables : in Natural; words : in Natural) return Float is
        fleschKincaidIndex : Float;
    begin
        fleschKincaidIndex := 0.39 * (Float(words / sentences));
        fleschKincaidIndex := fleschKincaidIndex + (11.8 * Float(syllables / words));
        fleschKincaidIndex := fleschKincaidIndex - 15.59;        
        return fleschKincaidIndex;
    end Flesch_Kincaid;
begin
    New_Line;
    put_line("Welcome to the Flesch Index Calculator!");
    New_Line;
    put_line("To begin, input a file name and the Flesch readability index");
    put_line("along with the Flesch-Kincaid grade level will be calculated.");
    New_Line;
    put_line("Enter a file name: ");
    get_line(fileName);
    open(File, in_file, to_string(fileName));
    
    loop
        exit when end_of_file(File);
        
        -- Read line from file and convert to all lowercase
        get_line(File, lineIn);
        lineIn := to_unbounded_string(Ada.Strings.Fixed.Translate(to_string(lineIn), Ada.Strings.Maps.Constants.Lower_Case_Map));
        
        for i in 1..Length(lineIn) loop
            if ((Element(lineIn, i)) = 'a')
            or ((Element(lineIn, i)) = 'e')
            or ((Element(lineIn, i)) = 'i')
            or ((Element(lineIn, i)) = 'o')
            or ((Element(lineIn, i)) = 'u')
            or ((Element(lineIn, i)) = 'y') then
                syllables := syllables + 1;
                j := i + 2;
                if (j <= Length(lineIn)) then
                    if ((Element(lineIn, i)) = 'e')
                    and ((Element(lineIn, i + 1)) = 's')
                    and not Is_Letter(Element(lineIn, i + 2)) then
                        syllables := syllables - 1;
                    end if;
                end if;
                
                j := i + 2;
                if (j <= Length(lineIn)) then
                    if ((Element(lineIn, i)) = 'e')
                    and ((Element(lineIn, i + 1)) = 'd')
                    and not Is_Letter(Element(lineIn, i + 2)) then
                        syllables := syllables - 1;
                    end if;
                end if;
                
                j := i + 1;
                if (j <= Length(LineIn)) then
                    if ((Element(lineIn, i)) = 'e')
                    and not Is_Letter(Element(lineIn, i + 1)) then
                        syllables := syllables - 1;
                    end if;
                end if;
                
                j := i + 1;
                if (j <= Length(lineIn)) then
                    if ((Element(lineIn, j)) = 'a')
                    or ((Element(lineIn, j)) = 'e')
                    or ((Element(lineIn, j)) = 'i')
                    or ((Element(lineIn, j)) = 'o')
                    or ((Element(lineIn, j)) = 'u')
                    or ((Element(lineIn, j)) = 'y') then
                        syllables := syllables - 1;
                    end if;
                end if;
            elsif ((Element(lineIn, i)) = ' ') then
                words := words + 1;
            CharLoop:
                -- under 3 letter words
                for k in 1..3 loop
                    if (i + k) = Length(lineIn) then exit CharLoop; end if;
                    if ((Element(lineIn, i + k)) = ' ') then
                        put(Element(lineIn, i + k - 2) & Element(lineIn, i + k - 1));
                        new_line;
                        syllables := syllables + 1;
                    end if;
                end loop CharLoop;
                -- Verify that next character is indeed a character
                if ((Element(lineIn, i + 1)) = ' ') then words := words - 1; end if;
            elsif ((Element(lineIn, i)) = '.')
               or ((Element(lineIn, i)) = '!')
               or ((Element(lineIn, i)) = '?')
               or ((Element(lineIn, i)) = ':')
               or ((Element(lineIn, i)) = ';') then
                sentences := sentences + 1;
            end if;
        end loop;
    end loop;
    close (File);
    words := words + 1;
    
    New_Line;
    put("Flesch Index:");
    fleschIndex := 206.835 - (1.015 * (Float(words) / Float(sentences))) - (84.6 * (Float(syllables) / Float(words)));    
    put(Integer'Image(Integer(fleschIndex)));
    put(" (");
    put(Integer'Image(syllables));
    put(" syllables in");
    put(Integer'Image(words));
    put(" words in");
    put(Integer'Image(sentences));
    if (sentences > 1) then put(" sentences )"); else put(" sentence )"); end if;
    
    New_Line;
    put("Readability: ");
    case Integer(fleschIndex) is
        when 90..100 => put("Very easy");
        when 80..89 => put("Easy");
        when 70..79 => put("Fairly easy");
        when 60..69 => put("""Plain English""");
        when 50..59 => put("Fairly difficult");
        when 30..49 => put("Difficult");
        when 0..29 => put("Very difficult");
        when others => null;
    end case;
    
    New_Line;
    put("Flesch-Kincaid Level:");
    fleschIndex := Flesch_Kincaid(sentences, syllables, words);
    Ada.Float_Text_IO.put(fleschIndex, 2, 2, 0);
    New_Line;
    New_Line;
end;