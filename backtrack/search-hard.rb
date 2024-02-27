
GRID_COLUMN     = 11
GRID_ROW        = 5

=begin
        There are 8 pieces that can be defined in a 3x3 grid
        there are 4 pieces that can be defined in a 2x4 grid

=end
module kanoodle_puzzles
        # These tiles are defined in a 3x3 grid
        x_tile = [[0,1,0], [1,1,1], [0,1,1]]
        zzag_tile = [[2,0,0],[2,2,0],[0,2,2]]
        short_L_tile = [[0,0,0],[0,0,3],[3,3,3]]
        lshort_L_tile = [[0,0,4],[0,0,4],[4,4,4]]
        cube_tile = [[0,0,0],[0,5,5],[0,5,5]]
        cube_s_tile = [[0,0,6],[0,6,6],[0,6,6]]
        m_tile = [[0,7,7],[0,7,0],[0,7,7]]
        small_L_tile = [[0,0,0],[0,8,0],[0,8,8]]

        # These tiles are defined in a 4x4 grid
        mosin_tile = [[9,0,0,0],[9,9,0,0], [9,0,0,0], [9,0,0,0]]
        stick_tile = [[10,0,0,0],[10,0,0,0],[10,0,0,0],[10,0,0,0]]
        long_L_tile = [[11,0,0,0],[11,0,0,0],[11,0,0,0],[11,11,0,0]]
        curve_L_tile = [[0,12,0,0],[12,12,0,0],[12,0,0,0],[12,0,0,0]]
end

puzzle_tiles = [x_tile, zzag_tile, short_L_tile, lshort_L_tile, cube_tile, cube_s_tile, m_tile, 
small_L_tile, mosin_tile, stick_tile, long_L_tile, curve_L_tile]

# Will rotate tile based off a mix of rotate transpose and reverse
def rotate_tile(tile)
        # annaershova.github.io/blog/2015/07/22/how-to-rotate-a-matrix-in-ruby/
        rotated_tile = []
        tile.transpose.each do |x|
                rotated_tile << x.reverse
        end

        rotated_tile
end

# Will flip a tile 
def flip(tile)
       # We only need to worry about two types of tiles so i'll be lazy tonight baby
       flipped_tile = []
       tile.each do |x|
                flipped_tile << x.reverse
       end

       flipped_tile
end

def place(grid, tile, row, col)

end

def does_overlap(grid, tile, row, col)
        

        true
end

def out_of_bounds(grid, tile, row, col)

end

def find_free_space(grid, row, col)


        return value1, value2 # Returns an array of two elements representing or row col
end

def backtrack(grid, tile, n, row, col)

        # Should return the grid if we've explored all puzzle pieces for this path
        if n == puzzle_tiles.length
                return grid
        end

        row_col = find_free_space(grid, row, col) 

        # Update the grid without the selected tilepiece
        puzzle_tiles.slice(n, -1).each do | piece |
               
               rotation_count = 0
               flipped = false
               while rotation_count < 4
                       
                       if not out_of_bounds(grid, tile, row, col)
                              if not does_overlap(grid, tile, row, col)
                                        # Place the piece
                                        # increment n
                                        return backtrack(grid, tile, n, row, col)
                              end
                       end

                       rotation_count += 1
                       if rotation_count == 4 and not flipped
                               rotation_count = 0
                               # flip here
                               flipped = !flipped
                       end

                       # rotate piece
               end
               # If we reach here, that means we have not found an optimal grid, so return nada
               return []
        end

        # Never reaches here 
end



# Start off with an empty grid of 11 columns per row
grid = Array.new(GRID_ROW) { Array.new(GRID_COLUMN) }

# Provide an initial piece and place it anywhere within the grid
p backtrack(grid, kanoodle_puzzles::cube_tile,0, row, col)
