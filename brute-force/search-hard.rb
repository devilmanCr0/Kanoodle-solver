
GRID_COLUMN     = 11
GRID_ROW        = 5

=begin
        There are 8 pieces that can be defined in a 3x3 grid
        there are 4 pieces that can be defined in a 2x4 grid

=end
module kanoodle_puzzles
        # These tiles are defined in a 3x3 grid
        x_tile = [[0,1,0], [1,1,1], [0,1,1]]
        zzag_tile = [[1,0,0],[1,1,0],[0,1,1]]
        short_L_tile = [[0,0,0],[0,0,1],[1,1,1]]
        lshort_L_tile = [[0,0,1],[0,0,1],[1,1,1]]
        cube_tile = [[0,0,0],[0,1,1],[0,1,1]]
        cube_s_tile = [[0,0,1],[0,1,1],[0,1,1]]
        m_tile = [[0,1,1],[0,1,0],[0,1,1]]
        small_L_tile = [[0,0,0],[0,1,0],[0,1,1]]

        # These tiles are defined in a 4x4 grid
        mosin_tile = [[1,0,0,0],[1,1,0,0], [1,0,0,0], [1,0,0,0]]
        stick_tile = [[1,0,0,0],[1,0,0,0],[1,0,0,0],[1,0,0,0]]
        long_L_tile = [[1,0,0,0],[1,0,0,0],[1,0,0,0],[1,1,0,0]]
        curve_L_tile = [[0,1,0,0],[1,1,0,0],[1,0,0,0],[1,0,0,0]]
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



def brute_force(grid, tile, row, col)
        tiles_placed = 0
        puzzle_length = puzzle_tiles.length
        while tiles_placed < puzzle_length

        end


        # This approach will check all paths starts from initial piece
        # A tile piece can flip and rotate
        
        # place piece and, check for overlapping
                # If it does, rotate
                # If it does not, check it's out of bounds
                        # if so, rotate to position and jump to parent nest condition (overlapping)
                      


        # place piece and check if it's out of bounds
                # If so, rotate until valid position

end



# Start off with an empty grid of 11 columns per row
grid = Array.new(GRID_ROW) { Array.new(GRID_COLUMN) }

# Provide an initial piece and place it anywhere within the grid
brute_force(grid, kanoodle_puzzles::cube_tile, row, col)
