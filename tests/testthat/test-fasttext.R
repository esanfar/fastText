
#------------------------------------------------------------------------- data
path_read = file.path(getwd(), "example_text.txt")
default_write_path = file.path(getwd(), 'save_model_vecs')
path_write_vecs = file.path(default_write_path, 'word_vectors')
path_write_logs = file.path(default_write_path, 'model_logs.txt')
path_supervised = file.path(getwd(), 'cooking_supervised.txt')
#------------------------------------------------------------------------- 


context('tests for all functions')


#=========================
# print usage of functions
#=========================


testthat::test_that("it prints information for the 'printDumpUsage' function", {
  
  testthat::expect_output( printDumpUsage() )
})


testthat::test_that("it prints information for the 'printNNUsage' function", {
  
  testthat::expect_output( printNNUsage() )
})


testthat::test_that("it prints information for the 'printPredictUsage' function", {
  
  testthat::expect_output( printPredictUsage() )
})


testthat::test_that("it prints information for the 'printPrintNgramsUsage' function", {
  
  testthat::expect_output( printPrintNgramsUsage() )
})


testthat::test_that("it prints information for the 'printPrintSentenceVectorsUsage' function", {
  
  testthat::expect_output( printPrintSentenceVectorsUsage() )
})


testthat::test_that("it prints information for the 'printPrintWordVectorsUsage' function", {
  
  testthat::expect_output( printPrintWordVectorsUsage() )
})


testthat::test_that("it prints information for the 'printQuantizeUsage' function", {
  
  testthat::expect_output( printQuantizeUsage() )
})


testthat::test_that("it prints information for the 'printTestLabelUsage' function", {
  
  testthat::expect_output( printTestLabelUsage() )
})


testthat::test_that("it prints information for the 'printTestUsage' function", {
  
  testthat::expect_output( printTestUsage() )
})


testthat::test_that("it prints information for the 'printUsage' function", {
  
  testthat::expect_output( printUsage() )
})


testthat::test_that("it prints information about the parameters of a specified command", {
  
  testthat::expect_output( print_parameters(command = 'supervised') )
})


#==============================
# 'fasttext_interface' function   [ 'expect_true' and 'expect_output' ]
#==============================


testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'cbow' command", {
  
  list_params = list(command = 'cbow',
                     lr = 0.1,
                     dim = 5,
                     input = path_read,
                     output = path_write_vecs,
                     verbose = 2,
                     thread = 1)
  
  res = fasttext_interface(list_params,
                           path_output = path_write_logs,
                           MilliSecs = 100)
  
  out = list.files(default_write_path, full.names = F)
  
  testthat::expect_true( length(out) == 4 && all(out %in% c("DONT_DELETE_THIS_FILE.txt", "model_logs.txt", "word_vectors.bin", "word_vectors.vec")) )
})


testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'skipgram' command", {
  
  list_params = list(command = 'skipgram',
                     lr = 0.1,
                     dim = 5,
                     input = path_read,
                     output = path_write_vecs,
                     verbose = 2,
                     thread = 1)
  
  res = fasttext_interface(list_params,
                           path_output = path_write_logs,
                           MilliSecs = 100)
  
  out = list.files(default_write_path, full.names = F)
  
  testthat::expect_true( length(out) == 4 && all(out %in% c("DONT_DELETE_THIS_FILE.txt", "model_logs.txt", "word_vectors.bin", "word_vectors.vec")) )
})


testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'supervised' command", {
  
  list_params = list(command = 'supervised',
                     lr = 0.1,
                     dim = 5,
                     input = path_supervised,
                     output = path_write_vecs,
                     verbose = 2,
                     thread = 1)
  
  res = fasttext_interface(list_params,
                           path_output = path_write_logs,
                           MilliSecs = 100)
  
  out = list.files(default_write_path, full.names = F)
  
  testthat::expect_true( length(out) == 4 && all(out %in% c("DONT_DELETE_THIS_FILE.txt", "model_logs.txt", "word_vectors.bin", "word_vectors.vec")) )
})


testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'predict' and 'predict-prob' command", {
  
  list_params = list(command = 'predict',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     test_data = file.path(getwd(), 'cooking_valid.txt'),
                     k = 1,
                     th = 0.0)
  
  res = fasttext_interface(list_params, path_output = file.path(default_write_path, 'preds_valid.txt'))
  
  out_preds = list.files(default_write_path, full.names = F)
  out_preds = ('preds_valid.txt' %in% out_preds)
  read_preds_valid = utils::read.table(file.path(default_write_path, 'preds_valid.txt'), quote="\"", comment.char="")
  ncol_valid = ncol(read_preds_valid) == 1                    # single column output
  
  list_params = list(command = 'predict-prob',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     test_data = file.path(getwd(), 'cooking_valid.txt'),
                     k = 1,
                     th = 0.0)
  
  res = fasttext_interface(list_params, path_output = file.path(default_write_path, 'preds_valid.txt'))
  
  out_preds_prob = list.files(default_write_path, full.names = F)
  out_preds_prob = ('preds_valid.txt' %in% out_preds_prob)
  read_preds_valid = utils::read.table(file.path(default_write_path, 'preds_valid.txt'), quote="\"", comment.char="")
  ncol_valid_prob = ncol(read_preds_valid) == 2             # 2-column output (probabilities, too)
  
  testthat::expect_true( all(c(out_preds, out_preds_prob)) && all(ncol_valid, ncol_valid_prob) )
})



testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'test-label' command", {
  
  list_params = list(command = 'test-label',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     test_data = file.path(getwd(), 'cooking_valid.txt'),
                     k = 5,
                     th = 0.0)
  
  res = fasttext_interface(list_params, path_output = file.path(default_write_path, 'preds_valid.txt'))
  
  out_preds_prob = list.files(default_write_path, full.names = F)
  out_preds_prob = ('preds_valid.txt' %in% out_preds_prob)
  read_preds_valid = utils::read.table(file.path(default_write_path, 'preds_valid.txt'), quote="\"", comment.char="")
  ncol_valid_prob = ncol(read_preds_valid) == 10             # 10-column output (precision & recall, too)

  testthat::expect_true( ncol_valid_prob )
})



testthat::test_that("the 'fasttext_interface' function prints information to the R session (precision, recall) when using the 'test' command", {

  list_params = list(command = 'test',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     test_data = file.path(getwd(), 'cooking_valid.txt'),
                     k = 5,
                     th = 0.0)          # it prints precision, recall to the R session (only)
  
  testthat::expect_output( fasttext_interface(list_params) )
})


testthat::test_that("the 'fasttext_interface' function will create an .ftz file when using the 'quantize' command", {
  
  list_params = list(command = 'quantize',
                     input = file.path(default_write_path, 'word_vectors.bin'),
                     output = path_write_vecs)
  
  res = fasttext_interface(list_params)
  out_ftz = list.files(default_write_path, pattern = '.ftz')
  
  testthat::expect_true( length(out_ftz) == 1 )
})


testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'print-word-vectors' command", {
  
  list_params = list(command = 'print-word-vectors',
                     model = file.path(default_write_path, 'word_vectors.bin'))
  
  out_data = file.path(default_write_path, 'preds_valid.txt')
  
  res = fasttext_interface(list_params,
                           path_input = file.path(getwd(), 'queries.txt'),
                           path_output = out_data)
  
  read_word_vecs = utils::read.table(out_data, quote="\"", comment.char="")
  
  testthat::expect_true( nrow(read_word_vecs) == 5 && ncol(read_word_vecs) == 6 )
})


testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'print-sentence-vectors' command", {
  
  list_params = list(command = 'print-sentence-vectors',
                     model = file.path(default_write_path, 'word_vectors.bin'))
  
  out_data = file.path(default_write_path, 'preds_valid.txt')
  
  res = fasttext_interface(list_params,
                           path_input = file.path(getwd(), 'text_sentence.txt'),
                           path_output = out_data)
  
  read_word_vecs = utils::read.table(out_data, quote="\"", comment.char="")         # the 3rd and 4th rows must give the same output because they are the same sentences
  
  testthat::expect_true( nrow(read_word_vecs) == 5 && ncol(read_word_vecs) == 5 && all(read_word_vecs[3, ] == read_word_vecs[4, ]) )
})



testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'print-ngrams' command", {
  
  list_params = list(command = 'skipgram', 
                     lr = 0.1, 
                     dim = 5,
                     input = path_read,
                     output = path_write_vecs, 
                     verbose = 2, 
                     thread = 1,
                     minn = 2, 
                     maxn = 2)
  
  res = fasttext_interface(list_params, path_output = path_write_logs, MilliSecs = 100)
  
  list_params = list(command = 'print-ngrams',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     word = 'word')
  
  out_data = file.path(default_write_path, 'preds_valid.txt')
  
  res = fasttext_interface(list_params, path_output = out_data)
  
  read_ngrams = utils::read.table(out_data, quote="\"", comment.char="")
  
  testthat::expect_true( all(dim(read_ngrams) == c(5, 6)) )        # 'print-ngrams' prints to R session too, just use : res = fasttext_interface(list_params, path_output = "")
})



testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'nn' command", {
  
  list_params = list(command = 'nn',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     k = 5,
                     query_word = 'word')
  
  out_data = file.path(default_write_path, 'preds_valid.txt')
  
  res = fasttext_interface(list_params, path_output = out_data)
  
  read_nn = utils::read.table(out_data, quote="\"", comment.char="")
  
  testthat::expect_true( all(nrow(read_nn) == list_params[['k']] && ncol(read_nn) == 2) )        
})



testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'analogies' command", {
  
  list_params = list(command = 'analogies',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     k = 5)
  
  out_data = file.path(default_write_path, 'preds_valid.txt')
  
  res = fasttext_interface(list_params, path_input = file.path(getwd(), 'analogy_queries.txt'), path_output = out_data)
  
  # the 'analogy_queries.txt' file contains 4 triplets and I'm looking for 5 analogies for each triplet.
  # therefore the output file should contain : 4 * 5 + 4 = 24 rows ( I've added a 4 because after each k-analogies I've added a empty line )
  
  read_analogies = utils::read.table(out_data, quote="\"", comment.char="", blank.lines.skip = FALSE)
  
  testthat::expect_true( all(nrow(read_analogies) == (4 * 5 + 4) && ncol(read_analogies) == 2) )        
})



testthat::test_that("the 'fasttext_interface' function writes output to folder when using the 'dump' command", {
  
  list_params = list(command = 'dump',
                     model = file.path(default_write_path, 'word_vectors.bin'),
                     option = 'args')
  
  out_data = file.path(default_write_path, 'preds_valid.txt')
  
  res = fasttext_interface(list_params, path_output = out_data, remove_previous_file = TRUE)
  
  read_dump = utils::read.table(out_data, quote="\"", comment.char="")
  
  testthat::expect_true( all(dim(read_dump) == c(13, 2)) )        
})

