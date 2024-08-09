// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is auto-generated by the Ballerina OpenAPI tool.

// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/io;

configurable boolean isLiveServer = ?;
configurable string token = ?;
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";
configurable string apiKey = isLiveServer ? token : "";

final ConnectionConfig config = {auth: {token: apiKey}};
final Client baseClient = check new Client(config, serviceUrl);
final string fileName = "sample.jsonl";

// Models

@test:Config {}
isolated function testListModels() returns error? {

    ListModelsResponse modelsResponse = check baseClient->/models.get();

    test:assertEquals(modelsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(modelsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {}
isolated function testRetrieveModel() returns error? {

    ListModelsResponse modelsResponse = check baseClient->/models.get();

    string modelId = "gpt-3.5-turbo";

    modelId = modelsResponse.data[0].id;

    Model modelResponse = check baseClient->/models/[modelId].get();

    test:assertEquals(modelResponse.id, modelId, "Model id mismatched");
    test:assertTrue(modelResponse.hasKey("object"), "Response does not have the key 'object'");

}

// @test:Config {
//     dependsOn: [testCreateFineTuningJob, testListModels, testRetrieveModel]
// }
// isolated function testDeleteModel() returns error? {

//     byte[] fileContent = check io:fileReadBytes(fileName);

//     CreateFileRequest fileRequest = {
//         file: {fileContent, fileName},
//         purpose: "fine-tune"
//     };

//     OpenAIFile fileResponse = check baseClient->/files.post(fileRequest);

//     string fileId = fileResponse.id;

//     ListModelsResponse modelsResponse = check baseClient->/models.get();

//     // string modelId = modelsResponse.data[0].id;
//     string modelId = "gpt-3.5-turbo";

//     CreateFineTuningJobRequest fineTuneRequest = {
//         model: modelId,
//         training_file: fileId
//     };

//     FineTuningJob fineTuneResponse = check baseClient->/fine_tuning/jobs.post(fineTuneRequest);

//     string modelIdCreated = fineTuneResponse.model;

//     DeleteModelResponse modelResponseDelete = check baseClient->/models/[modelIdCreated].delete();

//     test:assertEquals(modelResponseDelete.id, modelIdCreated, "Model id mismatched");
//     test:assertTrue(modelResponseDelete.hasKey("object"), "Response does not have the key 'object'");
// }

// // Files

@test:Config {}
isolated function testListFiles() returns error? {

    ListFilesResponse filesResponse = check baseClient->/files.get();

    test:assertEquals(filesResponse.'object, "list", "Object type mismatched");
    test:assertTrue(filesResponse.hasKey("data"), "Response does not have the key 'data'");

}

@test:Config {
    dependsOn: [testListFiles]
}
isolated function testCreateFile() returns error? {

    byte[] fileContent = check io:fileReadBytes(fileName);

    CreateFileRequest fileRequest = {
        file: {fileContent, fileName},
        purpose: "fine-tune"
    };

    OpenAIFile fileResponse = check baseClient->/files.post(fileRequest);

    test:assertEquals(fileResponse.purpose, "fine-tune", "Purpose mismatched");
    test:assertTrue(fileResponse.id !is "", "File id is empty");

    string fileId = fileResponse.id;

    DeleteFileResponse fileResponseDelete = check baseClient->/files/[fileId].delete();

    test:assertEquals(fileResponseDelete.id, fileId, "File id mismatched");
    test:assertTrue(fileResponseDelete.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFile]
}
isolated function testRetrieveFile() returns error? {

    ListFilesResponse filesResponse = check baseClient->/files.get();

    string fileId = filesResponse.data[0].id;

    OpenAIFile fileResponse = check baseClient->/files/[fileId].get();

    test:assertEquals(fileResponse.id, fileId, "File id mismatched");
    test:assertTrue(fileResponse.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFile, testRetrieveFile, testListFiles]
}
isolated function testDownloadFile() returns error? {

    byte[] fileContent = check io:fileReadBytes(fileName);

    CreateFileRequest fileRequest = {
        file: {fileContent, fileName},
        purpose: "fine-tune"
    };

    OpenAIFile fileResponse = check baseClient->/files.post(fileRequest);

    string fileId = fileResponse.id;

    byte[] fileContentDownload = check baseClient->/files/[fileId]/content.get();
}

@test:Config {
    dependsOn: [testCreateFile, testRetrieveFile, testListFiles, testDownloadFile]
}
isolated function testDeleteFile() returns error? {
    
    byte[] fileContent = check io:fileReadBytes(fileName);

    CreateFileRequest fileRequest = {
        file: {fileContent, fileName},
        purpose: "fine-tune"
    };

    OpenAIFile fileResponse = check baseClient->/files.post(fileRequest);

    string fileId = fileResponse.id;

    DeleteFileResponse fileResponseDelete = check baseClient->/files/[fileId].delete();

    test:assertEquals(fileResponseDelete.id, fileId, "File id mismatched");
    test:assertTrue(fileResponseDelete.hasKey("object"), "Response does not have the key 'object'");
}

// // Fine Tuning Jobs

@test:Config {}
isolated function testListPaginatedFineTuningJobs() returns error? {

    ListPaginatedFineTuningJobsResponse jobsResponse = check baseClient->/fine_tuning/jobs.get();

    test:assertEquals(jobsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(jobsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testListPaginatedFineTuningJobs, testListModels, testCreateFile, testRetrieveFile, testListFiles, testDownloadFile, testDeleteFile]
}
isolated function testCreateFineTuningJob() returns error? {

    byte[] fileContent = check io:fileReadBytes(fileName);

    CreateFileRequest fileRequest = {
        file: {fileContent, fileName},
        purpose: "fine-tune"
    };

    OpenAIFile fileResponse = check baseClient->/files.post(fileRequest);

    string fileId = fileResponse.id;

    ListModelsResponse modelsResponse = check baseClient->/models.get();

    // string modelId = modelsResponse.data[0].id;
    string modelId = "gpt-3.5-turbo";

    CreateFineTuningJobRequest fineTuneRequest = {
        model: modelId,
        training_file: fileId
    };

    FineTuningJob fineTuneResponse = check baseClient->/fine_tuning/jobs.post(fineTuneRequest);
        
    test:assertTrue(fineTuneResponse.hasKey("object"), "Response does not have the key 'object'");
    test:assertTrue(fineTuneResponse.hasKey("id"), "Response does not have the key 'id'");

    string fine_tuning_job_id = fineTuneResponse.id;

    FineTuningJob jobResponse = check baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/cancel.post();

    test:assertEquals(jobResponse.id, fine_tuning_job_id, "Job id mismatched");
    test:assertTrue(jobResponse.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob]
}
isolated function testRetrieveFineTuningJob() returns error? {

    ListPaginatedFineTuningJobsResponse jobsResponse = check baseClient->/fine_tuning/jobs.get();

    string jobId = jobsResponse.data[0].id;

    FineTuningJob jobResponse = check baseClient->/fine_tuning/jobs/[jobId].get();

    test:assertEquals(jobResponse.id, jobId, "Job id mismatched");
    test:assertEquals(jobResponse.'object, "fine_tuning.job", "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob]
}
isolated function testListFineTuningEvents() returns error? {

    string fine_tuning_job_id = "ftjob-qxrbfm03AOBVju8HYytXc0lN";

    ListPaginatedFineTuningJobsResponse jobsResponse = check baseClient->/fine_tuning/jobs.get();

    fine_tuning_job_id = jobsResponse.data[0].id;

    ListFineTuningJobEventsResponse eventsResponse = check baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/events.get();

    test:assertEquals(eventsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(eventsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob]
}
isolated function testListFineTuningJobCheckpoints() returns error? {

    string fine_tuning_job_id = "ftjob-qxrbfm03AOBVju8HYytXc0lN";

    ListPaginatedFineTuningJobsResponse jobsResponse = check baseClient->/fine_tuning/jobs.get();

    fine_tuning_job_id = jobsResponse.data[0].id;

    ListFineTuningJobCheckpointsResponse checkpointsResponse = check  baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/checkpoints.get();

    test:assertEquals(checkpointsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(checkpointsResponse.hasKey("data"), "Response does not have the key 'data'");
}

// @test:Config {
//     dependsOn: [testCreateFineTuningJob]
// }
// isolated function testCancelFineTuningJob() returns error? {

//     string fine_tuning_job_id = "ftjob-qxrbfm03AOBVju8HYytXc0lN";

//     ListPaginatedFineTuningJobsResponse jobsResponse = check baseClient->/fine_tuning/jobs.get();

//     fine_tuning_job_id = jobsResponse.data[0].id;

//     FineTuningJob jobResponse = check baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/cancel.post();

//     test:assertEquals(jobResponse.id, fine_tuning_job_id, "Job id mismatched");
//     test:assertTrue(jobResponse.hasKey("object"), "Response does not have the key 'object'");
// }